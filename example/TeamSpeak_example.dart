import 'package:teamspeak3/teamspeak3.dart';

void main() async {
  var ts3 = new TeamSpeak3(username: 'root', password: 'mysecurepassword');
  await ts3.connect();
}
