import 'package:teamspeak3/teamspeak3.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    TeamSpeak3 ts3;

    setUp(() {
      ts3 = TeamSpeak3();
    });

    test('First Test', () async {
      expect(await ts3.connect(), isNotEmpty);
    });
  });
}
