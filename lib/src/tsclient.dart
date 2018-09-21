import 'dart:async';

enum ReasonIdentifier {
  REASON_KICK_CHANNEL, // 4: kick client from channel
  REASON_KICK_SERVER // 5: kick client from server
}

class Client {
  int _clid;
  int _cldbid;
  int _cid;
  int _cgid;
  String _uniqueid;
  String _nickname;
  bool _talk;
  bool _listen;
  bool _away;
  String _awayMessage;
  String _country;
  String _ip;
  int _connectionTime;
  var ts;

  /// Client class constructor.
  Client(var ts3, int clid) {
    ts = ts3;

    if (clid == null) throw 'Invalid CLID!';

    _clid = clid;
  }

  /// Get client info.
  Future<Client> updateInfo([bool force = true]) async {
    List<Map> tsInfo = await ts.send('clientinfo clid=$_clid');

    // Temporary workaround
    while (tsInfo[0]['cid'] == null) {
      tsInfo = await ts.send('clientinfo clid=$_clid');

      if (tsInfo[0]['id'] != 0 && tsInfo[0]['id'] != null)
        throw 'clientinfo failed: $_clid, $tsInfo';
    }

    _cid = tsInfo[0]['cid'];
    _cldbid = tsInfo[0]['client_database_id'];
    _cgid = tsInfo[0]['client_channel_group_id'];
    _uniqueid = ts.decode(tsInfo[0]['client_unique_identifier']);
    _nickname = tsInfo[0]['client_nickname'];
    _talk = tsInfo[0]['client_output_muted'] == 0 &&
        tsInfo[0]['client_output_hardware'] == 1;
    _listen = tsInfo[0]['client_input_muted'] == 0 &&
        tsInfo[0]['client_input_hardware'] == 1;
    _away = tsInfo[0]['client_away'] == 1;
    _awayMessage = ts.decode(tsInfo[0]['client_away_message']);
    _country = tsInfo[0]['client_country'];
    _ip = tsInfo[0]['connection_client_ip'];
    _connectionTime = tsInfo[0]['connection_connected_time'];
    return this;
  }

  /// Sends a message to a client.
  /// The message is already properly escaped.
  Future<List<Map>> message(String message) async {
    return ts.send(
        'sendtextmessage targetmode=1 target=$_clid msg=${ts.encode(message)}' +
            '\n');
  }

  /// Move a client to a channel given its cid.
  Future<List<Map>> move(int cid) async {
    var reply = await ts.send('clientmove clid=$_clid cid=$cid');
    updateInfo(true);
    return reply;
  }

  /// Kick a client from the server or the current channel.
  /// The reason is already properly escaped.
  Future<List<Map>> kick(String reason,
      [ReasonIdentifier reasonId =
          ReasonIdentifier.REASON_KICK_CHANNEL]) async {
    int id;
    if (reasonId == ReasonIdentifier.REASON_KICK_CHANNEL) {
      id = 4;
    } else {
      id = 5;
    }
    return await ts.send(
        'clientkick clid=$_clid reasonid=$id reasonmsg=${ts.encode(reason)}');
  }

  /// Update Client's name.
  /// The name is already properly escaped.
  Future<List<Map>> setNickname(String name) async {
    return await ts.send('clientupdate client_nickname=${ts.encode(name)}');
  }

  /// Client's ID.
  int get clid => _clid;

  /// Client's Database ID.
  int get cldbid => _cldbid;

  /// Channel(where the client is ) ID.
  int get cid => _cid;

  /// Client's channel group.
  int get cgid => _cgid;

  /// Clients's unique ID.
  String get uniqueid => _uniqueid;

  /// Client's nickname.
  String get nickname => _nickname;

  /// True if the client can speak(can use the microphone and is not muted), false otherwise.
  bool get talk => _talk;

  /// True if the client can listen(can hear and it's not muted), false otherwise.
  bool get listen => _listen;

  /// True if the client is in away status, false otherwise.
  bool get away => _away;

  /// If away the away message, otherwise null.
  String get awayMessage => _awayMessage;

  /// Client's 2 Country code.
  String get country => _country;

  /// Client's IP.
  String get ip => _ip;

  /// Client's connection time.
  int get connectionTime => _connectionTime;
}
