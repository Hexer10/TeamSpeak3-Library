library teamspeak3.definitions;

/// Messages' modes.
class HostMessageMode {
  /// Don't display anything.
  static const none = HostMessageMode._(0);

  /// Display message in chatlog.
  static const log = HostMessageMode._(1);

  /// Display message in modal dialog.
  static const modal = HostMessageMode._(2);

  /// Display message in modal dialog and close connection.
  static const modalQuit = HostMessageMode._(3);

  /// Message mode id.
  final int id;

  const HostMessageMode._(this.id);

  @override
  String toString() => '$id';
}

/// Host banner modes.
class HostBannerMode {
  /// Don't adjust.
  static const noAdjust = HostBannerMode._(0);

  /// Adjust but ignore aspect ratio (like TeamSpeak 2).
  static const ignoreAspect = HostBannerMode._(1);

  /// Adjust and keep aspect ratio.
  static const keepAspect = HostBannerMode._(2);

  /// Host banner mode id.
  final int id;

  const HostBannerMode._(this.id);

  @override
  String toString() => '$id';
}

/// Codecs.
class Codec {
  /// Speex narrowband (mono, 16bit, 8kHz)
  static const speexNarrowband = Codec(0);

  /// Speex wideband (mono, 16bit, 16kHz)
  static const speexWideband = Codec(1);

  /// Speex ultra-wideband (mono, 16bit, 32kHz)
  static const speexUltrawideband = Codec(2);

  /// Celt mono (mono, 16bit, 48kHz)
  static const mono = Codec(3);

  /// Codec id.
  final int id;

  /// Codec
  const Codec(this.id);

  @override
  String toString() => '$id';
}

/// Codec encryption modes.
class CodecEncryptionMode {
  /// Configure per channel.
  static const cryptIndividual = CodecEncryptionMode._(0);

  /// Globally disabled.
  static const cryptDisabled = CodecEncryptionMode._(1);

  /// Globally enabled.
  static const speexUltrawideband = CodecEncryptionMode._(2);

  /// Codec encryption mode id.
  final int id;

  const CodecEncryptionMode._(this.id);

  @override
  String toString() => '$id';
}

/// Target message modes.
class TextMessageTargetMode {
  /// Target is a client.
  static const client = TextMessageTargetMode._(1);

  /// Target is a channel.
  static const channel = TextMessageTargetMode._(2);

  /// Target is a server.
  static const server = TextMessageTargetMode._(3);

  /// Message target id.
  final int id;

  const TextMessageTargetMode._(this.id);

  @override
  String toString() => '$id';
}

/// Log levels.
class LogLevel {
  /// Error.
  static const error = TextMessageTargetMode._(1);

  /// Warning.
  static const warning = TextMessageTargetMode._(2);

  /// Debug.
  static const debug = TextMessageTargetMode._(3);

  /// Info.
  static const info = TextMessageTargetMode._(4);

  /// Loglevel id.
  final int id;

  const LogLevel._(this.id);

  @override
  String toString() => '$id';
}

/// Reason identifiers.
class ReasonIdentifier {
  /// Kick the client from the channel.
  static const kickChannel = ReasonIdentifier._(4);

  /// Kick the client from the server.
  static const kickServer = ReasonIdentifier._(5);

  /// Identifier id.
  final int id;

  const ReasonIdentifier._(this.id);

  @override
  String toString() => '$id';
}

/// Permission group database types.
class PermissionGroupDatabaseTypes {
  /// Template group.
  static const typeTemplate = PermissionGroupDatabaseTypes._(0);

  /// Regular group.
  static const typeRegular = PermissionGroupDatabaseTypes._(1);

  /// Global query group.
  static const typeQuery = PermissionGroupDatabaseTypes._(2);

  /// Permission database group id.
  final int id;

  const PermissionGroupDatabaseTypes._(this.id);

  @override
  String toString() => '$id';
}

/// Permission group types.
class PermissionGroupTypes {
  /// Server group permission.
  static const serverGroup = PermissionGroupTypes._(0);

  /// Client permission.
  static const globalClient = PermissionGroupTypes._(1);

  /// Channel permission.
  static const channel = PermissionGroupTypes._(2);

  /// Channel group permission.
  static const channelGroup = PermissionGroupTypes._(3);

  /// Channel client permission.
  static const channelClient = PermissionGroupTypes._(4);

  /// Permission group id.
  final int id;

  const PermissionGroupTypes._(this.id);

  @override
  String toString() => '$id';
}

/// Token types.
class TokenType {
  /// Server group token (id1={groupID} id2=0)
  static const serverGroup = ReasonIdentifier._(4);

  /// Channel group token (id1={groupID} id2={channelID})
  static const kickServer = ReasonIdentifier._(5);

  /// Token id.
  final int id;

  const TokenType._(this.id);

  @override
  String toString() => '$id';
}

/// Channel proprieties.
class ChannelProprieties {
  /// Channel's name.
  String channelName;

  /// Channel's topic
  String channelTopic;

  /// Channel's description
  String channelDescription;

  /// Channel's (encrypted) password.
  String channelPassword;

  /// True if the channel has a password. (NOT Changeable)
  bool channelHasPassword;

  /// Channel's codec. [Codec]
  Codec channelCodec;

  /// Channel's codec quality.
  int channelCodecQuality;

  /// Channel's max clients.
  int channelMaxClients;

  /// Channel's max family clients.
  int channelMaxFamilyClients;

  /// Channel's order.
  int channelOrder;

  /// True if the channel is permanent.
  bool channelPermanent;

  /// True if the channel is semipermanent.
  bool channelSemipermanent;

  /// True if the channel is temporary.
  bool channelTemporary;

  /// True if the channel the default one.
  bool channelDefault;

  /// True if the channel's max clients are unlimited.
  bool channelMaxClientsUnlimited;

  /// True if the channel's max family clients are unlimited.
  bool channelMaxFamilyClientsUnlimited;

  /// True if the channel's max family clients are inherited.
  bool channelMaxFamilyClientsInherited;

  /// Channel needed talk power.
  int channelNeededTalkPower;

  /// Channel's phonetic name.
  String channelPhoneticName;

  /// Channel's filepath. (NOT Changeable)
  String channelFilepath;

  /// True if the channel silence is forced. (NOT Changeable)
  bool channelForceSilent;

  /// Channel's icon id.
  int channelIconId;

  /// True if the channel codec is unecrypted.
  bool channelCodecIsUnecrypted;

  /// Parent channel's id.
  int cpid;

  /// Channel proprities
  ChannelProprieties(
      {this.channelName,
      this.channelTopic,
      this.channelDescription,
      this.channelPassword,
      this.channelHasPassword,
      this.channelCodec,
      this.channelCodecQuality,
      this.channelMaxClients,
      this.channelMaxFamilyClients,
      this.channelOrder,
      this.channelPermanent,
      this.channelSemipermanent,
      this.channelTemporary,
      this.channelDefault,
      this.channelMaxClientsUnlimited,
      this.channelMaxFamilyClientsUnlimited,
      this.channelMaxFamilyClientsInherited,
      this.channelNeededTalkPower,
      this.channelPhoneticName,
      this.channelFilepath,
      this.channelForceSilent,
      this.channelIconId,
      this.channelCodecIsUnecrypted,
      this.cpid,
      this.cid,
      this.channelCodecLatency,
      this.channelSecuritySalt,
      this.channelDeleteDelay,
      this.uid,
      this.bannerGfxUrl,
      this.bannerMode,
      this.secondsEmpty});

  /// Channel's id.
  int cid;

  /// Codec latency
  int channelCodecLatency;

  /// Security salt.
  String channelSecuritySalt;

  /// Channel delete delay.
  int channelDeleteDelay;

  /// Channel unique id.
  String uid;

  /// Banner GFX Url
  String bannerGfxUrl;

  /// Banner mode
  int bannerMode;

  /// Seconds empty
  int secondsEmpty;

  /// Convert the channel proprieties to map.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['channel_name'] = channelName;
    map['channel_topic'] = channelTopic;
    map['channel_description'] = channelDescription;
    map['channel_password'] = channelPassword;
    map['channel_codec'] = channelCodec?.id;
    map['channel_codec_quality'] = channelCodecQuality;
    map['channel_maxclients'] = channelMaxClients;
    map['channel_maxfamilyclients'] = channelMaxFamilyClients;
    map['channel_order'] = channelOrder;
    map['channel_flag_permanent'] = channelPermanent;
    map['channel_flag_semipermanent'] = channelSemipermanent;
    map['channel_flag_default'] = channelDefault;
    map['channel_codec_latency_factory'] = channelCodecLatency;
    map['channel_codec_is_unencrypted'] = channelCodecIsUnecrypted;
    map['channel_security_salt'] = channelSecuritySalt;
    map['channel_delete_delay'] = channelDeleteDelay;
    map['channel_unique_identifier'] = uid;
    map['channel_flag_maxclients_unlimited'] = channelMaxClientsUnlimited;
    map['channel_flag_maxfamilyclients_unlimited'] =
        channelMaxFamilyClientsUnlimited;
    map['channel_flag_maxfamilyclients_inherited'] =
        channelMaxFamilyClientsInherited;
    map['channel_needed_talk_power'] = channelNeededTalkPower;
    map['channel_name_phonetic'] = channelPhoneticName;
    map['channel_icon_id'] = channelIconId;
    map['channel_banner_gfx_url'] = bannerGfxUrl;
    map['channel_banner_mode'] = bannerMode;
    map['seconds_empty'] = secondsEmpty;
    map['channel_flag_temporary'] = channelTemporary;
    map['cpid'] = cpid;
    map.removeWhere((_, v) => v == null);
    return map;
  }
}
