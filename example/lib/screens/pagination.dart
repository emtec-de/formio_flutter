import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:provider/provider.dart';

class PaginationPage extends StatefulWidget {
  @override
  _PaginationPageState createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage>
    implements ClickListener {
  PageController controller;
  FormCollection _formCollection;
  WidgetProvider widgetProvider;
  Future<List<Widget>> _widgets;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    widgetProvider = Provider.of<WidgetProvider>(context);
    _widgets ??= _buildWidget(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('FormIO.Flutter with wizard'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Widget>>(
        future: _widgets,
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return (snapshot.hasData)
                  ? Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: controller,
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (value) => setState(
                              () => _index = value,
                            ),
                            children: snapshot.data,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                onPressed: (_index == 0)
                                    ? null
                                    : () {
                                        controller.animateToPage(
                                          _index - 1,
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.linear,
                                        );
                                      },
                                splashColor: Colors.blue[50],
                                child: Text(
                                  "back".toUpperCase(),
                                  style: TextStyle(
                                    color: Color(0xFF0074E4),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    for (int i = 0;
                                        i < snapshot.data.length;
                                        i++)
                                      i == _index
                                          ? _buildPageIndicator(true)
                                          : _buildPageIndicator(false),
                                  ],
                                ),
                              ),
                              FlatButton(
                                onPressed: (_index != snapshot.data.length - 1)
                                    ? () => controller.animateToPage(_index + 1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.linear)
                                    : () => onClicked(""),
                                splashColor: Colors.blue[50],
                                child: (_index != snapshot.data.length - 1)
                                    ? Text(
                                        "next".toUpperCase(),
                                        style: TextStyle(
                                          color: Color(0xFF0074E4),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Text(
                                        "save".toUpperCase(),
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        )
                      ],
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
    String _json = await rootBundle.loadString('assets/multi.json');
    _formCollection = FormCollection.fromJson(json.decode(_json));
    Map<String, dynamic> defaultMapper = {
      "foamingDetergentUsed": "9999999999999999999999999999999999",
      "concentration1": "1e+34",
      "gmPsPerformance": "9999999999999999999999999999999999",
      "testedBy": "9999999999999999999999999999999999",
      "waterTemperature": "acceptable",
      "dryPickup": "unacceptable",
      "collected": "1e+34"
    };
    var tempo = await parseFormCollectionDefaultValueMap(
        _formCollection, defaultMapper);
    return WidgetParserBuilder.buildWidgets(
        tempo, context, this, widgetProvider);
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void onClicked(String event) {
    print("CLICKED");
  }
}
