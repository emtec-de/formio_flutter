import 'package:flutter/material.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';

class RightIconWidgetParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return Icon(
      (map.rightIcon != null)
          ? getIconUsingPrefix(name: map.rightIcon)
          : Icons.circle,
      size: (map.rightIcon != null) ? 20 : 0,
      color: Colors.white,
    );
  }

  @override
  String get widgetName => "rightIcon";
}
