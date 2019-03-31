library teamspeak3.command;

import 'reply.dart';

class Command {
  final Reply _data;

  static const private = 1;
  static const channel = 2;
  static const server = 3;

  int _targetmode;
  String _rawMsg;
  int _invokerid;
  String _invokername;

  int get targetmode => _targetmode;
  String _invokeruid;

  String _command;
  List<String> _params;

  final _spaceReg = RegExp(r' +(?= )');

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

  String get rawMsg => _rawMsg;

  int get invokerid => _invokerid;

  String get invokername => _invokername;

  String get invokeruid => _invokeruid;

  String get command => _command;

  List<String> get params => _params;
}
