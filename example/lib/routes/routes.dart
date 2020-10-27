import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../menu.dart';
import '../screens/pagination.dart';
import '../screens/demonstration.dart';

Route generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case 'menu':
      return MaterialPageRoute(builder: (context) => MenuPage());
      break;
    case 'pagination':
      return MaterialPageRoute(builder: (context) => PaginationPage());
      break;
    case 'demonstration':
      return MaterialPageRoute(
          builder: (context) =>
              DemonstrationPage(argument: settings.arguments));
      break;
    default:
      return MaterialPageRoute(builder: (context) => MenuPage());
  }
}
