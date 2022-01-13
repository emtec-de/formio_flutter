import 'package:flutter/material.dart';
import 'package:formio_flutter/formio_flutter.dart';

import 'routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormioWidgetProvider(
      child: MaterialApp(
        title: 'FormIo.Flutter',
        initialRoute: 'menu',
        onGenerateRoute: generateRoutes,
      ),
    );
  }
}
