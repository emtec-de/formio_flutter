import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  String _json = "";
  FormCollection _formCollection;

  String directory(String name) {
    var dir = Directory.current.path;
    return File('$dir/$name').readAsStringSync();
  }

  test('Returns the object associated with the json as it should be', () async {
    _json = directory('test/test_resources/textfield.json');
    _formCollection = FormCollection.fromJson(json.decode(_json));
    expect(_formCollection, isA<FormCollection>());
  });

  testWidgets(
      'Throws an ProviderNotFoundException due to the provider not being setted',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          _json = directory('test/test_resources/textfield.json');
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
            _json = directory('test/test_resources/textfield.json');
            _formCollection = FormCollection.fromJson(json.decode(_json));
            expect(_formCollection, isA<FormCollection>());
            expect(Provider.of<WidgetProvider>(context), isA<WidgetProvider>());
            return Placeholder();
          },
        ),
      ),
    );
  });
}
