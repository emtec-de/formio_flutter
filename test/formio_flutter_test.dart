import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

import 'package:formio_flutter/formio_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  String _json = "";
  FormCollection _formCollection;

  String directory(String name) {
    var dir = Directory.current.path;
    return File('$dir/test/test_resources/$name').readAsStringSync();
  }

  test('Returns the object associated with the json as it should be', () async {
    _json = directory('textfield.json');
    _formCollection = FormCollection.fromJson(json.decode(_json));
    expect(_formCollection, isA<FormCollection>());
  });

  testWidgets(
      'Throws an ProviderNotFoundException due to the provider not being setted',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          _json = directory('textfield.json');
          _formCollection = FormCollection.fromJson(json.decode(_json));
          expect(_formCollection, isA<FormCollection>());

          expect(
              () => WidgetParserBuilder.buildWidgets(
                  _formCollection, context, NonResponseWidgetClickListener()),
              throwsA(isInstanceOf<ProviderNotFoundException>()));
          return Placeholder();
        },
      ),
    );
  });

  testWidgets('Check if the provider is correctly assigned',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<WidgetProvider>(
            create: (context) => WidgetProvider(),
          ),
        ],
        child: Builder(
          builder: (BuildContext context) {
            _json = directory('textfield.json');
            _formCollection = FormCollection.fromJson(json.decode(_json));
            expect(_formCollection, isA<FormCollection>());
            expect(Provider.of<WidgetProvider>(context), isA<WidgetProvider>());
            return Placeholder();
          },
        ),
      ),
    );
  });

  testWidgets('Check if the provider is correctly assigned',
      (WidgetTester tester) async {
    _json = directory('textfield.json');
    _formCollection = FormCollection.fromJson(json.decode(_json));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<WidgetProvider>(
            create: (context) => WidgetProvider(),
          ),
        ],
        child: Builder(
          builder: (BuildContext context) {
            expect(_formCollection, isA<FormCollection>());
            expect(Provider.of<WidgetProvider>(context), isA<WidgetProvider>());
            return Placeholder();
          },
        ),
      ),
    );
  });

  testWidgets('Check if the List of widget is correctly assigned',
      (WidgetTester tester) async {
    _json = directory('textfield.json');
    _formCollection = FormCollection.fromJson(json.decode(_json));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<WidgetProvider>(
            create: (context) => WidgetProvider(),
          ),
        ],
        child: Builder(
          builder: (BuildContext context) {
            expect(_formCollection, isA<FormCollection>());
            expect(
                WidgetParserBuilder.buildWidgets(
                    _formCollection, context, NonResponseWidgetClickListener()),
                isA<List<Widget>>());
            return Placeholder();
          },
        ),
      ),
    );
  });

  testWidgets('Check if the List of widget is correctly assigned',
      (WidgetTester tester) async {
    _json = directory('textfield.json');
    _formCollection = FormCollection.fromJson(json.decode(_json));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<WidgetProvider>(
            create: (context) => WidgetProvider(),
          ),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              expect(_formCollection, isA<FormCollection>());
              expect(
                  WidgetParserBuilder.buildWidgets(_formCollection, context,
                      NonResponseWidgetClickListener()),
                  isA<List<Widget>>());
              return Placeholder();
            },
          ),
        ),
      ),
    );
  });

  testWidgets('Check if the List contains a textfield',
      (WidgetTester tester) async {
    _json = directory('textfield.json');
    _formCollection = FormCollection.fromJson(json.decode(_json));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<WidgetProvider>(
            create: (context) => WidgetProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Material App',
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    expect(_formCollection, isA<FormCollection>());
                    List<Widget> _list = WidgetParserBuilder.buildWidgets(
                        _formCollection,
                        context,
                        NonResponseWidgetClickListener());
                    return ListView(
                      children: _list,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
    //final list = find.byType(ListView);
    //expect(list, ListView());
  });
}
