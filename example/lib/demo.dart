import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:provider/provider.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> implements ClickListener {
  Future<List<Widget>> _widgets;

  @override
  Widget build(BuildContext context) {
    _widgets ??= _buildWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Provider<WidgetProvider>(
        create: (_) => WidgetProvider(),
        // we use `builder` to obtain a new `BuildContext` that has access to the provider
        builder: (context, child) => FutureBuilder<List<Widget>>(
          future: _widgets,
          builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  print("DATA");
                } else {
                  print("NO");
                }
                return (snapshot.hasData)
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => snapshot.data[index],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
                break;
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.none:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> _buildWidget(BuildContext context) async {
    final resp = await rootBundle.loadString('assets/textfield.json');
    var formCollection = FormCollection.fromJson(json.decode(resp));
    print("COL: ${formCollection.components.length}");
    return WidgetParserBuilder.buildWidgets(formCollection, context, this);
  }

  @override
  void onClicked(String event) {
    print("clicked");
  }
}
