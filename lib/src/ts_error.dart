library teamspeak3.error;

class TSError {
  int _id;
  String _message;
  final Map<String, dynamic> error;

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

  int get id => _id;

  String get message => _message;

  String get msg => _message;

  @override
  String toString() => 'id: $id, msg: $message';
}