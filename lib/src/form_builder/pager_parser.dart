import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

class PagerParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return PagerParserWidget(
      map: map,
      listener: listener,
    );
  }

  @override
  String get widgetName => "panel";
}

// ignore: must_be_immutable
class PagerParserWidget extends StatefulWidget {
  final Component map;
  final ClickListener listener;
  List<Widget> widgets = [];

  PagerParserWidget({this.map, this.listener});

  @override
  _PagerParserWidgetState createState() => _PagerParserWidgetState();
}

class _PagerParserWidgetState extends State<PagerParserWidget>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = new ScrollController();
  WidgetProvider widgetProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.widgets = WidgetParserBuilder.buildWidgetsByComponent(
        widget.map.component, context, widget.listener);
    bool isVisible = true;
    return StreamBuilder(
        stream: widgetProvider.widgetsStream,
        builder: (context, snapshot) {
          isVisible = (widget.map.conditional != null && snapshot.data != null)
              ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                      snapshot.data[widget.map.conditional.when].toString() ==
                          widget.map.conditional.eq)
                  ? widget.map.conditional.show
                  : true
              : true;
          return (!isVisible)
              ? Container()
              : SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: widget.widgets,
                  ),
                );
        });
  }
}
