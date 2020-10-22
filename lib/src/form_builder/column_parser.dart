import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

class ColumnParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return ColumnParserWidget(map: map);
  }

  @override
  String get widgetName => "columns";
}

// ignore: must_be_immutable
class ColumnParserWidget extends StatefulWidget {
  final Component map;
  List<Widget> widgets = [];

  ColumnParserWidget({this.map});

  @override
  _ColumnParserWidgetState createState() => _ColumnParserWidgetState();
}

class _ColumnParserWidgetState extends State<ColumnParserWidget> {
  Future<List<Widget>> _widgets;
  WidgetProvider widgetProvider;

  @override
  void didChangeDependencies() {
    widgetProvider = Provider.of<WidgetProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = true;
    _widgets ??= _buildWidget(context);
    return StreamBuilder(
      stream: widgetProvider.widgetsStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        isVisible = (widget.map.conditional != null && snapshot.data != null)
            ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                    snapshot.data[widget.map.conditional.when].toString() ==
                        widget.map.conditional.eq)
                ? widget.map.conditional.show
                : true
            : true;
        return (!isVisible)
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: FutureBuilder<List<Widget>>(
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
                                itemBuilder: (context, index) =>
                                    snapshot.data[index],
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
      },
    );
  }

  Future<List<Widget>> _buildWidget(BuildContext context) async {
    widget.map.columns.asMap().forEach((key, value) {
      value.component.asMap().forEach((key, ss) {
        widget.widgets.add(
            WidgetParserBuilder.build(ss, context, new DefaultClickListener()));
      });
    });
    return widget.widgets;
  }
}
