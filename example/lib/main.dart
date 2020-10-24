import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter_example/routes/routes.dart';

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
        Provider<WidgetProvider>(
          create: (context) => WidgetProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'FormIo.Flutter',
        initialRoute: 'menu',
        onGenerateRoute: generateRoutes,
      ),
    );
  }
}
