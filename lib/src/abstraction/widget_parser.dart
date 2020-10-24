import 'package:flutter/widgets.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';

abstract class WidgetParser {
  /// parse the json map into a flutter [widget].
  Widget parse(Component map, BuildContext context, ClickListener listener);

  /// name of the [widget]
  String get widgetName;
}
