import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => WidgetProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'FormIo.Flutter',
        initialRoute: 'menu',
        // initialRoute: 'custom_form',
        onGenerateRoute: generateRoutes,
      ),
    );
  }
}
