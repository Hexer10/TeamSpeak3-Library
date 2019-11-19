library teamspeak3.exceptions;

import 'ts_error.dart';

/// Exception thrown when a command returns an unexpected error.
class CommandException implements Exception {
  /// Custom message.
  final dynamic message;

  /// Failing command.
  final String command;

  /// TSError.
  final TSError error;

  /// The command that failed is required, additionally, a custom [message] or
  /// a [error] can be supplied.
  CommandException(this.command, {this.message, this.error});

  @override
  String toString() {
    var buffer = StringBuffer('Command $command failed! ');
    if (message != null) {
      buffer.writeln(message);
    }
    if (error != null) {
      buffer.writeln(error);
    }
    return buffer.toString();
  }
}
