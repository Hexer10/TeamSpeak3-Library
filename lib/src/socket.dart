library teamspeak3.socket;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'bot.dart';
import 'command.dart';
import 'exceptions.dart';
import 'reply.dart';
import 'ts_client.dart';

/// Wrapper for the TCP Socket to the TeamSpeak3 remove server.
class TeamSpeak3 {
  /// The remote server host.
  final InternetAddress host;

  /// The remote server port.
  final int port;

  /// The remote server username.
  final String username;

  /// The remote server password.
  final String password;

  /// The remove server id.
  final int server;

  /// Bot(client) instance.
  Bot bot;

  Socket _socket;

  int _count = 0;

  final Queue<String> _queue = Queue();
  final Queue<Completer<Reply<Map<String, String>>>> _replyQueue = Queue();
  final Map<int, StreamController<Reply>> _channelSubsMap = {};

  StreamController<Command> _onServerCommand;
  StreamController<Command> _onChannelCommand;
  StreamController<Command> _onPrivateCommand;
  StreamController<Reply> _onServerEvent;
  StreamController<Reply> _onChannelEvent;

  /// Every time a server message is sent a [Command] will be added
  /// to this server.
  Stream<Command> get onServerCommand => _onServerCommand.stream;

  /// Every time a channel message is sent a [Command] will be added
  /// to this server.
  Stream<Command> get onChannelCommand => _onChannelCommand.stream;

  /// When the bot receives a message it will be added to this stream.
  Stream<Command> get onPrivateCommand => _onPrivateCommand.stream;

  /// Called every time a server event happens.
  /// The first key will always be null, and the key will be the event name.
  Stream<Reply> get onServerEvent => _onServerEvent.stream;

  /// Called every time a channel event happens.
  /// The first key will always be null, and the key will be the event name.
  Stream<Reply> get onChannelEvent => _onChannelEvent.stream;

  /// [connect()] should be called after construction this class.
  /// You can specify a [server] that will be used in the authentication phase.
  TeamSpeak3(this.host, this.port, this.username, this.password,
      {this.server = 1}) {
    bot = Bot(this);

    _onPrivateCommand = StreamController<Command>.broadcast(
        onListen: () => write('servernotifyregister', {'event': 'textserver'}));

    _onChannelCommand = StreamController<Command>.broadcast(
        // ignore: lines_longer_than_80_chars
        onListen: () =>
            write('servernotifyregister', {'event': 'textchannel'}));

    _onPrivateCommand = StreamController<Command>.broadcast(
        // ignore: lines_longer_than_80_chars
        onListen: () =>
            write('servernotifyregister', {'event': 'textprivate'}));

    _onServerEvent = StreamController<Reply>.broadcast(
        onListen: () => write('servernotifyregister', {'event': 'server'}));

    _onChannelEvent = StreamController<Reply>.broadcast(
        onListen: () =>
            write('servernotifyregister', {'event': 'channel', 'id': 0}));
  }

  /// Connects to the remote server, authenticates to it, and selects the chosen
  /// server, if any of this process fail a [CommandException] will be thrown.
  Future<void> connect() async {
    _socket = await Socket.connect(host, port);
    _socket.listen(_onData);

    // Needed to keep alive the connection.
    Timer.periodic(Duration(minutes: 4, seconds: 50), (_) {
      write('whoami');
    });

    var login = await write('login', [
      username,
      password,
    ]);

    if (login.error.id != 0) {
      throw CommandException('login', error: login.error);
    }

    var use = await write('use', server);

    if (use.error.id != 0) {
      throw CommandException('use', error: use.error);
    }
  }

  /// Writes a command to the remote server.
  /// If the value is [Map] all the parameters will be encoded with the
  /// according keys, if it's an [Iterable] the command will have no keys,
  /// If another type is given [toString] will be called and the value will
  /// be appended to the command.
  Future<Reply> write(String command, [values]) {
    var data = StringBuffer(command.trim());

    if (values is Map) {
      values.forEach((k, v) {
        if (v == null) {
          data.write(' ${encode(k)}');
        } else {
          data.write(' ${encode(k)}=${encode(v)}');
        }
      });
    } else if (values is Iterable) {
      // ignore: avoid_function_literals_in_foreach_calls
      values.forEach((e) => data.write(' ${encode(e)}'));
    } else if (values != null) {
      data.write(' ${encode(values)}');
    }

    var completer = Completer<Reply<Map<String, String>>>();
    _queue.add('$data\n');
    _replyQueue.add(completer);
    _processQueue();
    return completer.future;
  }

  /// Notifies a specific channel.
  /// It's highly recommended to use instead [onChannelEvent]
  Stream<Reply> subToChannel(int cid) {
    if (_channelSubsMap.containsKey(cid)) {
      return _channelSubsMap[cid].stream;
    }

    var controller = StreamController<Reply>.broadcast(
        onListen: () =>
            write('servernotifyregister', {'event': 'channel', 'id': '$cid'}));
    _channelSubsMap[cid] = controller;

    return controller.stream;
  }

  /// Returns a [Client] instance given his cid.
  Future<Client> getClient(int cid) async {
    var client = Client(this, cid);
    await client.updateInfo();
    return client;
  }

  void _onData(info) {
    //print(data.runtimeType);
    var decoded = ascii.decode(info).replaceAll('\r', '').trim();

    //Skip the first packet.
    if (++_count == 1) {
      return;
    }

    var error = <String, String>{};
    var data = <Map<String, String>>[];

    var lines = decoded.split('\n');
    for (var line in lines) {
      if (line.startsWith('error')) {
        var params = line.substring(6).split(' ');
        for (var param in params) {
          final pos = param.indexOf('=');
          if (pos == -1) {
            error[param] = null;
            continue;
          }
          error[param.substring(0, pos)] = decode(param.substring(pos + 1));
        }
      } else {
        var sections = line.split('|');
        for (var section in sections) {
          var sectionMap = <String, String>{};
          var params = section.split(' ');
          for (var param in params) {
            final pos = param.indexOf('=');
            if (pos == -1) {
              sectionMap[param] = null;
              continue;
            }
            sectionMap[param.substring(0, pos)] =
                decode(param.substring(pos + 1));
          }
          data.add(sectionMap);
        }
      }
    }

    var reply = Reply(error, data);

    // Command
    if (decoded.startsWith('notifytextmessage')) {
      var cmd = Command(reply);
      switch (cmd.targetmode) {
        case Command.server:
          {
            _onServerCommand.add(cmd);
            break;
          }
        case Command.channel:
          {
            _onChannelCommand.add(cmd);
            break;
          }
        case Command.private:
          {
            _onPrivateCommand.add(cmd);
            break;
          }
      }
      return;
    } else if (decoded.startsWith('notifyserveredited')) {
      _onServerEvent.add(reply);
      return;
    } else if (decoded.startsWith('notifychanneledited') ||
        decoded.startsWith('notifychanneldescriptionchanged') ||
        decoded.startsWith('notifychannelpasswordchanged') ||
        decoded.startsWith('notifychanneldeleted') ||
        decoded.startsWith('notifychannelmoved')) {
      if (_onChannelEvent.hasListener) {
        _onChannelEvent.add(reply);
      }
      var controller = _channelSubsMap[int.parse(reply[0]['cid'])];
      controller?.add(reply);
      return;
    } else if (decoded.startsWith('notifychannelcreated')) {
      _onChannelEvent.add(reply);
      return;
    } else if (decoded.startsWith('notifycliententerview')) {
      if (_onChannelEvent.hasListener) {
        _onChannelEvent.add(reply);
      }

      if (_onServerEvent.hasListener && reply[0]['cfid'] == '0') {
        _onServerEvent.add(reply);
      }

      // Poorly implemented.
      _channelSubsMap[int.parse(reply[0]['cfid'])]?.add(reply);
      return;
    } else if (decoded.startsWith('notifyclientleftview') ||
        decoded.startsWith('notifyclientmoved')) {
      if (_onChannelEvent.hasListener) {
        _onChannelEvent.add(reply);
      }

      if (_onServerEvent.hasListener && reply[0]['ctid'] == '0') {
        _onServerEvent.add(reply);
      }

      // Poorly implemented.
      _channelSubsMap[int.parse(reply[0]['ctid'])]?.add(reply);
      return;
    }

    _replyQueue.removeFirst().complete(reply);
    _processQueue();
  }

  void _processQueue() {
    // Assure that only one command is send at the same time,
    // wait for a response before sending the next one.
    if (_queue.length != _replyQueue.length) {
      return;
    }

    if (_queue.isNotEmpty) {
      var data = _queue.removeFirst();
      _socket.write(data);
      print('Written $data');
    }
  }

  /// Encodes a string according to the TeamSpeak3 documentation.
  /// [toString] will be called to get the string.
  String encode(string) => string
      .toString()
      .replaceAll(r'\', r'\\')
      .replaceAll('/', r'\/')
      .replaceAll(' ', r'\s')
      .replaceAll('|', r'\p')
      //.replaceAll('\a', r'\a')
      .replaceAll('\b', r'\b')
      .replaceAll('\f', r'\f')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r')
      .replaceAll('\t', r'\t')
      .replaceAll('\v', r'\v');

  /// Decodes a string according to the TeamSpeak3 documentation.
  /// If the string is null, null will be returned.
  String decode(String string) {
    if (string == 'null') {
      return null;
    }
    return string
        .replaceAll(r'\\', r'\')
        .replaceAll(r'\/', '/')
        .replaceAll(r'\s', ' ')
        .replaceAll(r'\p', '|')
        .replaceAll(r'\a', '\a')
        .replaceAll(r'\b', '\b')
        .replaceAll(r'\f', '\f')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r', '\r')
        .replaceAll(r'\t', '\t')
        .replaceAll(r'\v', '\v');
  }
}
