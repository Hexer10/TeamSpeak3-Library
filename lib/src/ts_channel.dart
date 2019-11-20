library teamspeak3.channel;

import 'dart:async';

import 'package:teamspeak3/definitions.dart';

import 'exceptions.dart';
import 'reply.dart';
import 'socket.dart';

// TODO(Hexah): Add channel proprieties list. (const class).

/// (TeamSpeak3) Channel wrapper.
class Channel {
  /// Channel's ID.
  final int cid;
  final TeamSpeak3 _ts;

  ChannelProprieties _proprieties;

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

    _proprieties = ChannelProprieties()
      ..channelName = convertedReply[0]['channel_name']
      ..channelTopic = convertedReply[0]['channel_topic']
      ..channelDescription = convertedReply[0]['channel_description']
      ..channelPassword = convertedReply[0]['channel_password']
      ..channelCodec = Codec(convertedReply[0]['channel_codec'])
      ..channelCodecQuality = convertedReply[0]['channel_codec_quality']
      ..channelMaxClients = convertedReply[0]['channel_maxclients']
      ..channelMaxFamilyClients = convertedReply[0]['channel_maxfamilyclients']
      ..channelOrder = convertedReply[0]['channel_order']
      ..channelPermanent = convertedReply[0]['channel_flag_permanent'] == 1
      ..channelSemipermanent =
          convertedReply[0]['channel_flag_semipermanent'] == 1
      ..channelDefault = convertedReply[0]['channel_flag_default'] == 1
      ..codecLatency = convertedReply[0]['channel_codec_latency_factory']
      ..channelCodecIsUnecrypted =
          convertedReply[0]['channel_codec_is_unencrypted'] == 1
      ..channelSecuritySalt = convertedReply[0]['channel_security_salt']
      ..channelDeleteDelay = convertedReply[0]['channel_delete_delay']
      ..uid = convertedReply[0]['channel_unique_identifier']
      ..channelMaxClientsUnlimited =
          convertedReply[0]['channel_flag_maxclients_unlimited'] == 1
      ..channelMaxFamilyClientsUnlimited =
          convertedReply[0]['channel_flag_maxfamilyclients_unlimited'] == 1
      ..channelMaxFamilyClientsInherited =
          convertedReply[0]['channel_flag_maxfamilyclients_inherited'] == 1
      ..channelFilepath = convertedReply[0]['channel_filepath']
      ..channelNeededTalkPower = convertedReply[0]['channel_needed_talk_power']
      ..channelForceSilent = convertedReply[0]['channel_forced_silence'] == 0
      ..channelPhoneticName = convertedReply[0]['channel_name_phonetic']
      ..channelIconId = convertedReply[0]['channel_icon_id']
      ..bannerGfxUrl = convertedReply[0]['channel_banner_gfx_url']
      ..bannerMode = convertedReply[0]['channel_banner_mode']
      ..secondsEmpty = convertedReply[0]['seconds_empty']
      ..channelHasPassword = convertedReply[0]['channel_flag_password'] == 1
      ..channelTemporary = convertedReply[0]['channel_flag_temporary'] == 1
      ..cpid = convertedReply[0]['cpid']
      ..cid = convertedReply[0]['cid'];
  }

  /// Deletes the channel.
  /// If force is true the channel will be deleted even if there are clients
  /// in the channel.
  Future<Reply> delete({bool force = false}) =>
      _ts.write('channeldelete', {'cid': cid, 'force': force ? 1 : 0});

  /// Channel's name.
  String get name => _proprieties.channelName;

  /// Channel's topic.
  String get topic => _proprieties.channelTopic;

  /// Channel's description.
  String get description => _proprieties.channelDescription;

  /// Channel's (encrypted) password.
  String get password => _proprieties.channelPassword;

  /// Channel's codec.
  Codec get codec => _proprieties.channelCodec;

  /// Channel's codec quality.
  int get codecQuality => _proprieties.channelCodecQuality;

  /// Channel's max clients.
  int get maxClients => _proprieties.channelMaxClients;

  /// Channel's max family clients.
  int get maxFamilyClients => _proprieties.channelMaxFamilyClients;

  /// Channel's order.
  int get order => _proprieties.channelOrder;

  /// True if the channel is permanent.
  bool get permanent => _proprieties.channelPermanent;

  /// True if the channel is semipermanent.
  bool get semiPermanent => _proprieties.channelSemipermanent;

  /// True if the channel is the default channel.
  bool get defaultChannel => _proprieties.channelDefault;

  /// True if the channel has a password.
  bool get hasPassword => _proprieties.channelHasPassword;

  /// Channel's codec latency.
  int get codecLatency => _proprieties.codecLatency;

  /// True if the codec is unencrypted.
  bool get isCodecUnencrypted => _proprieties.channelCodecIsUnecrypted;

  /// Channel's security salt.
  String get securitySalt => _proprieties.channelSecuritySalt;

  /// Channel's delete delay.
  int get deleteDelay => _proprieties.channelDeleteDelay;

  /// Channel's unique id.
  String get uid => _proprieties.uid;

  /// True if the max clients are unlimited.
  bool get maxClientsUnlimited => _proprieties.channelMaxClientsUnlimited;

  /// True if the max family clients are unlimited.
  bool get maxFamilyClientsUnlimited =>
      _proprieties.channelMaxFamilyClientsUnlimited;

  /// True if the max family clients are inherited.
  bool get maxFamilyClientsInherited =>
      _proprieties.channelMaxFamilyClientsInherited;

  /// Channel's filepath.
  String get filepath => _proprieties.channelFilepath;

  /// Channel's needed talk power.
  int get neededTalkPower => _proprieties.channelNeededTalkPower;

  /// True if the silence is forced.
  bool get forcedSilence => _proprieties.channelForceSilent;

  /// Channel's phonetic name.
  String get phoneticName => _proprieties.channelPhoneticName;

  /// Channel's icon id.
  int get iconId => _proprieties.channelIconId;

  /// Channel's banner GFX Url.
  String get bannerGfxUrl => _proprieties.bannerGfxUrl;

  /// Channel's banner mode.
  int get bannerMode => _proprieties.bannerMode;

  /// Channel's seconds since it is empty.
  int get secondsEmpty => _proprieties.secondsEmpty;

  /// True if the channel is temporary.
  bool get temporary => _proprieties.channelTemporary;

  /// Channel parent's id.
  int get cpid => _proprieties.cpid;
}
