import 'package:flutter/material.dart';
import 'package:formio_flutter/src/bloc/widget_bloc.dart';

/// [WidgetProvider] use a Stream to notify all the custom widgets about any
/// change related.
///
/// Returns the data in a dynamic [Map<String, dynamic>].
class WidgetProvider extends InheritedWidget {
  final widgetBloc = WidgetBloc();
  static WidgetProvider _instance;

  factory WidgetProvider({Key key, Widget child}) {
    _instance = _instance ?? new WidgetProvider._(key: key, child: child);
    return _instance;
  }

  WidgetProvider._({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static WidgetBloc ofWidget(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<WidgetProvider>()).widgetBloc;
}
