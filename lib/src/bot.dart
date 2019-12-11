library teamspeak3.bot;

import 'dart:async';

import 'reply.dart';
import 'socket.dart';

class RawBot {
  Future<Reply> setNickname(String name) {}
}

///
class Bot extends RawBot {
  /// [TeamSpeak3] instance.
  final TeamSpeak3? ts;

  ///
  Bot(this.ts);

  /// Sets the bot nickname.
  @override
  Future<Reply> setNickname(String name) async =>
      ts?.write('clientupdate', {'client_nickname': name});
}
