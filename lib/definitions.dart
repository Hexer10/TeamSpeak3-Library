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
  static const speexNarrowband = Codec._(0);

  /// Speex wideband (mono, 16bit, 16kHz)
  static const speexWideband = Codec._(1);

  /// Speex ultra-wideband (mono, 16bit, 32kHz)
  static const speexUltrawideband = Codec._(2);

  /// Celt mono (mono, 16bit, 48kHz)
  static const mono = Codec._(3);

  /// Codec id.
  final int id;

  const Codec._(this.id);

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
