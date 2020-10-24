import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:provider/provider.dart';

class DemonstrationPage extends StatefulWidget {
  final String argument;

  DemonstrationPage({this.argument});

  @override
  _DemonstrationPageState createState() => _DemonstrationPageState();
}

class _DemonstrationPageState extends State<DemonstrationPage>
    implements ClickListener {
  Future<List<Widget>> _widgets;

  @override
  Widget build(BuildContext context) {
    _widgets ??= _buildWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('FormIO.Flutter'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Widget>>(
        future: _widgets,
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
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
    );
  }

  Future<List<Widget>> _buildWidget(BuildContext context) async {
    String _json;
    switch (widget.argument) {
      case "textfield":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "multiTextfields":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "buttons":
        _json = await rootBundle.loadString('assets/buttons.json');
        break;
      case "datetime":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "select":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "checkbox":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "file":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "signature":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "pagination":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      case "multi":
        _json = await rootBundle.loadString('assets/multi_textfields.json');
        break;
      default:
    }
    var formCollection = FormCollection.fromJson(json.decode(_json));
    return WidgetParserBuilder.buildWidgets(formCollection, context, this);
  }

  @override
  void onClicked(String event) {
    print("clicked");
  }
}
