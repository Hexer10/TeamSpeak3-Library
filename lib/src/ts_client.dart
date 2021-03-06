library teamspeak3.client;

import 'dart:async';

import '../definitions.dart';

import 'exceptions.dart';
import 'reply.dart';
import 'socket.dart';

/// (TeamSpeak3) Client wrapper.
class Client {
  /// Client's ID.
  final int clid;
  final TeamSpeak3 _ts;

  int _cldbid;
  int _cid;
  int _cgid;
  String _uniqueid;
  String _nickname;
  bool _talk;
  bool _listen;
  bool _away;
  String _awayMessage;
  String _country;
  String _ip;
  int _connectionTime;

  /// Requires the [TeamSpeak3] instance and a valid client id.
  Client(this._ts, this.clid);

  /// Updates the client info with parsing 'clientinfo'.
  Future<void> updateInfo() async {
    var reply = await _ts.write('clientinfo', {'clid': clid});

    if (reply.error.id != 0) {
      throw CommandException('clientinfo', error: reply.error);
    }

    var convertedReply = reply.parseNum();

    _cid = convertedReply[0]['cid'];
    _cldbid = convertedReply[0]['client_database_id'];
    _cgid = convertedReply[0]['client_channel_group_id'];
    _uniqueid = convertedReply[0]['client_unique_identifier'];
    _nickname = convertedReply[0]['client_nickname'];
    _talk = convertedReply[0]['client_output_muted'] == 0 &&
        convertedReply[0]['client_output_hardware'] == 1;
    _listen = convertedReply[0]['client_input_muted'] == 0 &&
        convertedReply[0]['client_input_hardware'] == 1;
    _away = convertedReply[0]['client_away'] == 1;
    _awayMessage = convertedReply[0]['client_away_message'];
    _country = convertedReply[0]['client_country'];
    _ip = convertedReply[0]['connection_client_ip'];
    _connectionTime = convertedReply[0]['connection_connected_time'];
  }

  /// Sends a message to a client.
  /// The message is already properly escaped.
  Future<Reply> message(String message) => _ts.write(
      'sendtextmessage', {'targetmode': 1, 'target': clid, 'msg': message});

  /// Pokes a client.
  /// The message is already properly escaped.
  Future<Reply> poke(String message) =>
      _ts.write('clientpoke', {'clid': clid, 'msg': message});

  /// Move a client to a channel given its id.
  Future<Reply> move(int cid, {bool updateProprieties = true}) async {
    var reply = await _ts.write('clientmove', {'clid': clid, 'cid': cid});
    if (updateProprieties) {
      await updateInfo();
    }
    return reply;
  }

  /// Kick a client from the server or the current channel.
  /// The reason is already properly escaped.
  Future<Reply> kick(
          {String reason = '',
          ReasonIdentifier reasonId = ReasonIdentifier.kickChannel}) =>
      _ts.write('clientkick',
          {'clid': clid, 'reasonid': reasonId, 'reasonmsg': reason});

  /// Client's Database ID.
  int get cldbid => _cldbid;

  /// Channel(where the client is ) ID.
  int get cid => _cid;

  /// Client's channel group.
  int get cgid => _cgid;

  /// Clients's unique ID.
  String get uniqueid => _uniqueid;

  /// Client's nickname.
  String get nickname => _nickname;

  /// True if the client can speak(can use the microphone and is not muted),
  /// false otherwise.
  bool get talk => _talk;

  /// True if the client can listen(can hear and it's not muted),
  /// false otherwise.
  bool get listen => _listen;

  /// True if the client is in away status, false otherwise.
  bool get away => _away;

  /// If away the away message, otherwise null.
  String get awayMessage => _awayMessage;

  /// Client's 2 Country code.
  String get country => _country;

  /// Client's IP.
  String get ip => _ip;

  /// Client's connection time.
  int get connectionTime => _connectionTime;
}
