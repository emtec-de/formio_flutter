import 'package:flutter/material.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class RightIconWidgetParser extends WidgetParser {
  final Color? color;
  RightIconWidgetParser({
    this.color,
  });

  /// Returns a [Widget] of type [Icon]
  @override
  Widget parse(
    Component map,
    BuildContext context,
    ClickListener? listener,
    WidgetProvider? widgetProvider,
  ) {
    return Icon(
      (map.rightIcon != null)
          ? getIconUsingPrefix(name: map.rightIcon!)
          : Icons.circle,
      size: (map.leftIcon != null) ? 20 : 0,
      color: color != null ? color : Colors.black,
    );
  }

  @override
  String get widgetName => "rightIcon";
}
