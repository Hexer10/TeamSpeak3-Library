library teamspeak3.exceptions;

import 'ts_error.dart';

class CommandException implements Exception {
  final dynamic message;
  final String command;
  final TSError error;

  CommandException(this.command, {this.message, this.error});

  @override
  String toString() {
    var buffer = StringBuffer('$command failed!');
    if (message != null) {
      buffer.writeln(message);
    }
    if (error != null) {
      buffer.writeln(error);
    }
    return buffer.toString();
  }
}