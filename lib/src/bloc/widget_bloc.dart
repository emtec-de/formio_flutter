import 'package:rxdart/rxdart.dart';

class WidgetBloc {
  /// Contains the information related to the [key] and [value] of every [parser] class.
  Map<String?, dynamic> _mapper = new Map();

  final BehaviorSubject<Map<String, dynamic>> _widgetController =
      new BehaviorSubject<Map<String, dynamic>>();

  /// Returns a [Stream] of [Map<String, dynamic].
  /// ```dart
  /// Map<String, dynamic> = {"textfield": "valueInTextField", "datetime": "2020/08/22"}
  Stream<Map<String, dynamic>> get widgetsStream => _widgetController.stream;

  clear() {
    _mapper.clear();
    _widgetController.sink.add({});
  }

  /// Check if the [newMap] param is already registed inside the [_mapper]
  ///
  /// and return a [Map<String, dynamic>].
  registerMap(Map<String?, dynamic> newMap) {
    newMap.forEach((key, value) {
      (_mapper.containsKey(key))
          ? _mapper.update(key!, (newVal) => value)
          : _mapper[key!] = value;
    });
    _widgetController.sink
        .add(_mapper.map((key, value) => MapEntry(key!, value)));
  }

  /// Close the Stream.
  void dispose() {
    _widgetController.close();
  }
}
