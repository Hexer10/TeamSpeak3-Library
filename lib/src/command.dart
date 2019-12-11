library teamspeak3.command;

import 'reply.dart';

/// Wrapper to better parse a ts3 command.
class Command {
  final Reply _data;

  /// Constant for a private message.
  static const private = 1;

  /// Constant for a channel message.
  static const channel = 2;

  /// Constant for a server message.
  static const server = 3;

  int _targetmode = -1;
  String _rawMsg = '';
  int? _invokerid;
  String? _invokername;

  /// Targetmode that can be check using the valid values:
  /// [private], [channel] or [server].
  int get targetmode => _targetmode;
  String? _invokeruid;

  String? _command;
  List<String>? _params;

  final _spaceReg = RegExp(r' +(?= )');

  /// Construct and parses the command given the [Reply].
  Command(Reply data) : _data = data.parseNum() {
    _rawMsg = _data[0]['msg'];
    _invokerid = _data[0]['invokerid'];
    _invokername = _data[0]['invokername'];
    _invokeruid = _data[0]['invokeruid'];

    _targetmode = _data[0]['targetmode'];
    _parseCmd(_rawMsg);
  }

  void _parseCmd(String msg) {
    // ignore: parameter_assignments
    msg = msg.trim().replaceAll(_spaceReg, '');
    var params = msg.split(' ');
    _command = params[0];
    _params = params.skip(1).toList();
  }

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'Command: $_command, Params: $_params, Invoker($_invokerid) $_invokername';

  /// Raw, unparsed message.
  String get rawMsg => _rawMsg;

  /// The client's id who invoked the command.
  int? get invokerid => _invokerid;

  /// The client's name of the invoker.
  String? get invokername => _invokername;

  /// The client's uid of the invoker.
  String? get invokeruid => _invokeruid;

  /// The command without any parameters.
  String? get command => _command;

  /// The command parameters.
  List<String>? get params => _params;
}
