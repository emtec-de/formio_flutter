import 'package:flutter/material.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';

class LeftIconWidgetParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return Icon(
      (map.leftIcon != null)
          ? getIconUsingPrefix(name: map.leftIcon)
          : Icons.circle,
      size: (map.leftIcon != null) ? 20 : 0,
      color: Colors.white,
    );
  }

  @override
  String get widgetName => "leftIcon";
}
