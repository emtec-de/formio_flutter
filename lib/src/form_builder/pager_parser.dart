import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// Extends the abstract class [WidgetParser]
class PagerParser extends WidgetParser {
  /// Returns a [Widget] of type [Pager]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return PagerParserWidget(
      map: map,
      listener: listener,
    );
  }

  /// [widgetName] => "panel"
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
    /// Declared [WidgetProvider] to consume the [Map<String, dynamic>] created from it.
    widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  /// Returns a [SingleChildScrollView] that has a [List<Widget>] contained in [Component.map.component]
  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.widgets = WidgetParserBuilder.buildWidgetsByComponent(
        widget.map.component, context, widget.listener);
    if (!widget.map.title.contains('Page') ||
        !widget.map.title.contains('page'))
      widget.widgets.insert(
        0,
        NeumorphicText(
          widget.map.title,
          textAlign: TextAlign.center,
          textStyle: NeumorphicTextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
          style: NeumorphicStyle(
              depth: 13.0, intensity: 0.90, color: Colors.black),
        ),
      );
    bool isVisible = true;
    return StreamBuilder(
        stream: widgetProvider.widgetBloc.widgetsStream,
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
                  child: Neumorphic(
                    child: Container(
                      decoration: BoxDecoration(color: widget.map.background),
                      child: Column(
                        children: widget.widgets,
                      ),
                    ),
                  ),
                );
        });
  }
}
