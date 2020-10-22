import 'dart:async';

class WidgetProvider {
  Map<String, dynamic> _mapper = new Map();
  final _widgetsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Function(Map<String, dynamic>) get widgetsSink =>
      _widgetsStreamController.sink.add;

  Stream<Map<String, dynamic>> get widgetsStream =>
      _widgetsStreamController.stream;

  void registerMap(Map<String, dynamic> newMap) {
    newMap.forEach((key, value) {
      (_mapper.containsKey(key))
          ? _mapper.update(key, (newVal) => value)
          : _mapper[key] = value;
    });
    widgetsSink(_mapper);
  }

  void dispose() {
    _widgetsStreamController?.close();
  }
}
