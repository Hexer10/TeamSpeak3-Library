library teamspeak3.bot;

import 'dart:async';

import 'reply.dart';
import 'socket.dart';

class Bot {

  final TeamSpeak3 ts;
  Bot(this.ts);

  Future<Reply> setNickname(String name) =>
      ts.write('clientupdate', {'client_nickname': name});
}