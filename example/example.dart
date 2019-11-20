import 'dart:async';
import 'dart:io';
import 'package:teamspeak3/teamspeak3.dart';

Future<void> main() async {
  var ts = TeamSpeak3(
      InternetAddress.loopbackIPv4, 10011, 'serveradmin', 'kmvqEOWa');

  await ts.connect();
  await ts.bot.setNickname('DartBot');
  var x = await ts.getChannel(4);
  print(x.uid);
}
