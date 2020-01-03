library teamspeak3.bot;

import 'dart:async';

import 'reply.dart';
import 'socket.dart';

/// Bot Query Client
class Bot {
  /// [TeamSpeak3] instance.
  final TeamSpeak3? ts;

  ///
  Bot(this.ts);

  /// Sets the bot nickname.
  Future<Reply> setNickname(String name) async =>
      ts!.write('clientupdate', {'client_nickname': name});
}
