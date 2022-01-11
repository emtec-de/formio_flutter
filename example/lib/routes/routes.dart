import 'package:flutter/material.dart';

import '../menu.dart';
import '../screens/custom_form.dart';
import '../screens/demonstration.dart';
import '../screens/pagination.dart';

Route generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case 'menu':
      return MaterialPageRoute(builder: (context) => MenuPage());
    case 'pagination':
      return MaterialPageRoute(builder: (context) => PaginationPage());
    case 'demonstration':
      return MaterialPageRoute(
          builder: (context) =>
              DemonstrationPage(argument: settings.arguments as String?));
    case 'custom_form':
      return MaterialPageRoute(
        builder: (context) => CustomForm(),
      );
    default:
      return MaterialPageRoute(builder: (context) => MenuPage());
  }
}
