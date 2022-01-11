import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:provider/provider.dart';

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> implements ClickListener {
  dynamic response;

  Future<List<Widget>> _widgets;
  WidgetProvider widgetProvider;
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    widgetProvider = Provider.of<WidgetProvider>(context);
    _widgets ??= _buildWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Form'),
      ),
      body: Builder(
        builder: (context) {
          _context = context;
          return FutureBuilder<List<Widget>>(
            future: _widgets,
            builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  print('snapshot data ${snapshot.hasData}');
                  print('snapshot error ${snapshot.hasError}');
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error in Form\n${snapshot.error}'),
                    );
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
                  print('waiting');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.none:
                  print('none');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  print('default');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          );
        },
      ),
    );
  }

  Future<List<Widget>> _buildWidget(BuildContext context) async {
    String _json = await rootBundle.loadString('assets/form.json');
    var formCollection = FormCollection.fromJson(json.decode(_json));
    List<Map<String, dynamic>> defaultMapper = [
      {'textField': ''},
    ];
    formCollection = await parseFormCollectionDefaultValueListMap(
      formCollection,
      defaultMapper,
    );
    print('formCollection.components ${formCollection.components.last.action}');

    return WidgetParserBuilder.buildWidgets(
      formCollection,
      context,
      this,
      widgetProvider,
    );
  }

  @override
  void onClicked(String event) async {
    if (event == 'print') {
      print("button clicked");
      Future<Map<String, dynamic>> formData =
          parseWidgets(WidgetParserBuilder.widgets);

      formData.then((Map<String, dynamic> formDataValue) async {
        if (await checkFields(WidgetParserBuilder.widgets)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill all the fields'),
            ),
          );
        } else {
          formDataValue.entries
              .forEach((MapEntry<String, dynamic> formEntyyMap) {
            print('value ${formEntyyMap.value.toString()}');
          });
          showAlert(
            'keys: ${formDataValue.keys}\nvalues: ${formDataValue.values}',
          );
        }

        // if (formDataValue.isNotEmpty) {
        //   print('formDataValue.isNotEmpty');
        // } else {
        //   print('formDataValue.isEmpty');
        // }

        // try {
        //   if (formDataValue.entries.last.value as bool == false) {
        //     print('Agreement not done');
        //   } else {
        //     print('Agreement done');
        //   }
        // } catch (e) {
        //   print(e);
        // }

        // for (int i = 0; i < formDataValue.values.length; i++) {
        //   formDataValue.values.any.call();
        //   if (formDataValue.values.toList()[i] == null) {
        //     print('Incomplete form');
        //   } else {
        //     showAlert(
        //       'keys: ${formDataValue.keys}\nvalues: ${formDataValue.values}',
        //     );
        //   }
        // }

        // for (int i = 0; i < formDataValue.keys.length; i++) {
        //   print(
        //     '${formDataValue.keys.toList()[i]} : ${formDataValue.values.toList()[i]}',
        //   );
        // }
      });
    }
  }

  showAlert(String text) {
    showDialog(
      context: _context,
      builder: (context) {
        return Scaffold(
          body: Center(
            child: Text('$text'),
          ),
        );
      },
    );
  }
}
