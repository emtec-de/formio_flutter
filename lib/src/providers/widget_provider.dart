import 'package:flutter/material.dart';
import 'package:formio_flutter/src/bloc/widget_bloc.dart';

/// [FormioWidgetProvider] use a Stream to notify all the custom widgets about any
/// change related.
///
/// Returns the data in a dynamic [Map<String, dynamic>].
class FormioWidgetProvider extends InheritedWidget {
  final widgetBloc = WidgetBloc();

  FormioWidgetProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FormioWidgetProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FormioWidgetProvider>();
}
