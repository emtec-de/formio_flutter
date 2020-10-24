import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formio_flutter_example/demo.dart';

Route generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case 'demo':
      return MaterialPageRoute(builder: (context) => Demo());
      break;
    default:
      return MaterialPageRoute(builder: (context) => Demo());
  }
}
