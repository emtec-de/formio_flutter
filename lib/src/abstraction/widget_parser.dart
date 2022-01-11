import 'package:flutter/widgets.dart';
import 'package:formio_flutter/formio_flutter.dart';

abstract class WidgetParser {
  /// parse the json map into a flutter [widget].
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider widgetProvider);

  /// name of the [widget]
  String get widgetName;
}
