library teamspeak3.channel;

import 'dart:async';

import 'exceptions.dart';
import 'reply.dart';
import 'socket.dart';

// TODO(Hexah): Add channel proprieties list. (const class).

/// (TeamSpeak3) Channel wrapper.
class Channel {
  /// Channel's ID.
  final int cid;
  final TeamSpeak3 _ts;

  String _name;
  String _topic;
  String _description;
  String _password;
  int _codec;
  int _codecQuality;
  int _maxClients;
  int _maxFamilyClients;
  int _order;
  bool _permanent;
  bool _semiPermanent;
  bool _default;
  bool _hasPassword;
  int _codecLatency;
  bool _isCodecUnencrypted;
  String _securitySalt;
  int _deleteDelay;
  String _uid;
  bool _maxClientsUnlimited;
  bool _maxFamilyClientsUnlimited;
  bool _maxFamilyClientsInherited;
  String _filepath;
  int _neededTalkPower;
  bool _forcedSilence;
  String _phoneticName;
  int _iconId;
  String _bannerGfxUrl;
  int _bannerMode;
  int _secondsEmpty;

  /// Requires the [TeamSpeak3] instance and a valid server id.
  Channel(this._ts, this.cid);

  /// Creates a new channel.
  /// A name is required and the channel proprieties can be provided.
  static Future<Channel> create(TeamSpeak3 ts, String name,
      {Map<String, dynamic> proprieties}) async {
    var reply = await ts
        .write('channelcreate', {'channel_name': name, ...?proprieties});

    var cReply = reply.parseNum();
    var channel = Channel(ts, cReply[0]['cid']);
    await channel.updateInfo();
    return channel;
  }

  /// Updates the client info with parsing 'channelinfo'.
  Future<void> updateInfo() async {
    var reply = await _ts.write('channelinfo', {'cid': cid});

    if (reply.error.id != 0) {
      throw CommandException('cid', error: reply.error);
    }

    var convertedReply = reply.parseNum();

    _name = convertedReply[0]['channel_name'];
    _topic = convertedReply[0]['channel_topic'];
    _description = convertedReply[0]['channel_description'];
    _password = convertedReply[0]['channel_password'];
    _codec = convertedReply[0]['channel_codec'];
    _codecQuality = convertedReply[0]['channel_codec_quality'];
    _maxClients = convertedReply[0]['channel_maxclients'];
    _maxFamilyClients = convertedReply[0]['channel_maxfamilyclients'];
    _order = convertedReply[0]['channel_order'];
    _permanent = convertedReply[0]['channel_flag_permanent'] == 1;
    _semiPermanent = convertedReply[0]['channel_flag_semipermanent'] == 1;
    _default = convertedReply[0]['channel_flag_default'] == 1;
    _codecLatency = convertedReply[0]['channel_codec_latency_factory'];
    _isCodecUnencrypted =
        convertedReply[0]['channel_codec_is_unencrypted'] == 1;
    _securitySalt = convertedReply[0]['channel_security_salt'];
    _deleteDelay = convertedReply[0]['channel_delete_delay'];
    _uid = convertedReply[0]['channel_unique_identifier'];
    _maxClientsUnlimited =
        convertedReply[0]['channel_flag_maxclients_unlimited'] == 1;
    _maxFamilyClientsUnlimited =
        convertedReply[0]['channel_flag_maxfamilyclients_unlimited'] == 1;
    _maxFamilyClientsInherited =
        convertedReply[0]['channel_flag_maxfamilyclients_inherited'] == 1;
    _filepath = convertedReply[0]['channel_filepath'];
    _neededTalkPower = convertedReply[0]['channel_needed_talk_power'];
    _forcedSilence = convertedReply[0]['channel_forced_silence'] == 0;
    _phoneticName = convertedReply[0]['channel_name_phonetic'];
    _iconId = convertedReply[0]['channel_icon_id'];
    _bannerGfxUrl = convertedReply[0]['channel_banner_gfx_url'];
    _bannerMode = convertedReply[0]['channel_banner_mode'];
    _secondsEmpty = convertedReply[0]['seconds_empty'];
  }

  /// Deletes the channel.
  /// If force is true the channel will be deleted even if there are clients
  /// in the channel.
  Future<Reply> delete({bool force = false}) =>
      _ts.write('channeldelete', {'cid': cid, 'force': force ? 1 : 0});

  /// Channel's name.
  String get name => _name;

  /// Channel's topic.
  String get topic => _topic;

  /// Channel's description.
  String get description => _description;

  /// Channel's (encrypted) password.
  String get password => _password;

  /// Channel's codec.
  int get codec => _codec;

  /// Channel's codec quality.
  int get codecQuality => _codecQuality;

  /// Channel's max clients.
  int get maxClients => _maxClients;

  /// Channel's max family clients.
  int get maxFamilyClients => _maxFamilyClients;

  /// Channel's order.
  int get order => _order;

  /// True if the channel is permanent.
  bool get permanent => _permanent;

  /// True if the channel is semipermanent.
  bool get semiPermanent => _semiPermanent;

  /// True if the channel is the default channel.
  bool get defaultChannel => _default;

  /// True if the channel has a password.
  bool get hasPassword => _hasPassword;

  /// Channel's codec latency.
  int get codecLatency => _codecLatency;

  /// True if the codec is unencrypted.
  bool get isCodecUnencrypted => _isCodecUnencrypted;

  /// Channel's security salt.
  String get securitySalt => _securitySalt;

  /// Channel's delete delay.
  int get deleteDelay => _deleteDelay;

  /// Channel's unique id.
  String get uid => _uid;

  /// True if the max clients are unlimited.
  bool get maxClientsUnlimited => _maxClientsUnlimited;

  /// True if the max family clients are unlimited.
  bool get maxFamilyClientsUnlimited => _maxFamilyClientsUnlimited;

  /// True if the max family clients are inherited.
  bool get maxFamilyClientsInherited => _maxFamilyClientsInherited;

  /// Channel's filepath.
  String get filepath => _filepath;

  /// Channel's needed talk power.
  int get neededTalkPower => _neededTalkPower;

  /// True if the silence is forced.
  bool get forcedSilence => _forcedSilence;

  /// Channel's phonetic name.
  String get phoneticName => _phoneticName;

  /// Channel's icon id.
  int get iconId => _iconId;

  /// Channel's banner GFX Url.
  String get bannerGfxUrl => _bannerGfxUrl;

  /// Channel's banner mode.
  int get bannerMode => _bannerMode;

  /// Channel's seconds since it is empty.
  int get secondsEmpty => _secondsEmpty;
}
