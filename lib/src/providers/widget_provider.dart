import 'dart:async';

/// [WidgetProvider] use a Stream to notify all the custom widgets about any
/// change related.
///
/// Returns the data in a dynamic [Map<String, dynamic>].
class WidgetProvider {
  /// Contains the information related to the [key] and [value] of every [parser] class.
  Map<String, dynamic> _mapper = new Map();

  /// Maintains a [broadcast] to all the widget tree.
  final _widgetsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Adds a [data] to the [widgetsSink].
  Function(Map<String, dynamic>) get widgetsSink =>
      _widgetsStreamController.sink.add;

  /// Returns a [Stream] of [Map<String, dynamic].
  /// ```dart
  /// Map<String, dynamic> = {"textfield": "valueInTextField", "datetime": "2020/08/22"}
  Stream<Map<String, dynamic>> get widgetsStream =>
      _widgetsStreamController.stream;

  /// Check if the [newMap] param is already registed inside the [_mapper]
  ///
  /// and uupdate/add the new information to the [_mapper].
  void registerMap(Map<String, dynamic> newMap) {
    newMap.forEach((key, value) {
      (_mapper.containsKey(key))
          ? _mapper.update(key, (newVal) => value)
          : _mapper[key] = value;
    });
    widgetsSink(_mapper);
  }

  /// Close the Stream.
  void dispose() {
    _widgetsStreamController?.close();
  }
}
