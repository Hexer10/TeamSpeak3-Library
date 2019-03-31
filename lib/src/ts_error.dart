library teamspeak3.error;

/// Error class to better parse all the socket responses.
class TSError {
  int _id;
  String _message;

  /// The error's [Map].
  final Map<String, dynamic> error;

  /// [TSError] constructor, requires the error [Map].
  TSError(this.error) {
    var id = error['id'];
    if (id is String) {
      _id = int.parse(id);
    } else if (id is int) {
      _id = id;
    } else if (id != null) {
      throw ArgumentError.value(
          id, 'id', 'Supported types are [int] or [String]');
    }

    _message = error['msg'];
  }

  /// Returns the [Error]'s [Map].
  Map<String, dynamic> asMap() => error;

  /// Returns the [Error]'s id.
  int get id => _id;

  /// Returns the [Error]'s message.
  String get message => _message;

  /// Same as [message].
  String get msg => _message;

  @override
  String toString() => 'id: $id, msg: $message';
}
