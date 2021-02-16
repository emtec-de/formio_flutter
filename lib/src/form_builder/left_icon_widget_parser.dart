import 'package:flutter/material.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';

/// Extends the abstract class [WidgetParser]
class LeftIconWidgetParser extends WidgetParser {
  final Color color;
  LeftIconWidgetParser({
    this.color,
  });

  /// Returns a [Widget] of type [Icon]
  @override
  Widget parse(
    Component map,
    BuildContext context,
    ClickListener listener,
    WidgetProvider widgetProvider,
  ) {
    return Icon(
      (map.leftIcon != null)
          ? getIconUsingPrefix(name: map.leftIcon)
          : Icons.circle,
      size: (map.leftIcon != null) ? 20 : 0,
      color: color != null ? color : Colors.black,
    );
  }

  /// [widgetName] => "leftIcon"
  @override
  String get widgetName => "leftIcon";
}
