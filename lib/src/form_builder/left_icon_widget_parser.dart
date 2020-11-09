import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';

/// Extends the abstract class [WidgetParser]
class LeftIconWidgetParser extends WidgetParser {
  /// Returns a [Widget] of type [Icon]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return NeumorphicIcon(
      (map.leftIcon != null)
          ? getIconUsingPrefix(name: map.leftIcon)
          : Icons.circle,
      size: (map.leftIcon != null) ? 20 : 0,
      style: NeumorphicStyle(color: Colors.white),
    );
  }

  /// [widgetName] => "leftIcon"
  @override
  String get widgetName => "leftIcon";
}
