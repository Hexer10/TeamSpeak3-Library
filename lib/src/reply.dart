library teamspeak3.error;

import 'dart:collection';

import 'ts_error.dart';

///Offers a better parsing over the TeamSpeak server response.
class Reply<T extends Map> extends ListBase<T> {
  final List<T> _data;

  /// [TSError] instance.
  TSError error;

  ///The error map and the ts3 server response are required.
  Reply(Map<String, dynamic> error, this._data) : error = TSError(error);

  /// Converts all the keys into a [num] where possible.
  Reply<Map<String, dynamic>> parseNum() {
    final list = <Map<String, dynamic>>[];
    for (var i = 0; i < length; i++) {
      this[i].forEach((k, v) {
        if (list.length <= i) {
          list.insert(i, <String, dynamic>{});
        }

        if (v == null) {
          list[i][k] = v;
        } else {
          var value = num.tryParse(v.trim());

          if (value == null) {
            list[i][k] = v;
          } else {
            list[i][k] = value;
          }
        }
      });
    }
    return Reply(error.asMap(), list);
  }

  @override
  int get length => _data.length;

  @override
  set length(int length) => _data.length = length;

  @override
  void operator []=(int index, T value) => _data[index] = value;

  @override
  T operator [](int index) => _data[index];

  @override
  void add(T value) => _data.add(value);

  @override
  void addAll(Iterable<T> all) => _data.addAll(all);

  @override
  String toString() => 'Error: $error\nData: $_data';
}
