import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class ColumnParser extends WidgetParser {
  /// Returns a [Widget] of type [Column]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      FormioWidgetProvider? widgetProvider) {
    return ColumnParserWidget(
      map: map,
      listener: listener,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "columns"
  @override
  String get widgetName => "columns";
}

// ignore: must_be_immutable
class ColumnParserWidget extends StatefulWidget {
  final Component? map;
  final FormioWidgetProvider? widgetProvider;
  List<Widget> widgets = [];
  ClickListener? listener;

  ColumnParserWidget({
    this.map,
    this.listener,
    this.widgetProvider,
  });

  @override
  _ColumnParserWidgetState createState() => _ColumnParserWidgetState();
}

class _ColumnParserWidgetState extends State<ColumnParserWidget> {
  Future<List<Widget>>? _widgets;

  @override
  Widget build(BuildContext context) {
    bool? isVisible = true;
    _widgets ??= _buildWidget(context);
    return StreamBuilder(
      stream: widget.widgetProvider!.widgetBloc.widgetsStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        isVisible = (widget.map!.conditional != null && snapshot.data != null)
            ? (snapshot.data!.containsKey(widget.map!.conditional!.when) &&
                    snapshot.data![widget.map!.conditional!.when].toString() ==
                        widget.map!.conditional!.eq)
                ? widget.map!.conditional!.show
                : !widget.map!.conditional!.show!
            : true;
        return (!isVisible!)
            ? SizedBox.shrink()
            : Neumorphic(
                child: Container(
                  //height: 200,
                  decoration: BoxDecoration(
                    color: widget.map!.background,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: FutureBuilder<List<Widget>>(
                      future: _widgets,
                      builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return (snapshot.hasData)
                                ? WrapSuper(
                                    wrapType: WrapType.balanced,
                                    alignment: WrapSuperAlignment.center,
                                    children: snapshot.data!,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
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
                ),
              );
      },
    );
  }

  /// Returns a [List<Widget>] contained in [Component.map.columns] and [Component.map.component]
  Future<List<Widget>> _buildWidget(BuildContext context) async {
    widget.map!.columns!.asMap().forEach(
      (key, value) {
        value.component!.asMap().forEach(
          (key, ss) {
            ss.total = widget.map!.columns!.length;
            widget.widgets.add(
              WidgetParserBuilder.build(
                ss,
                context,
                widget.listener,
                widget.widgetProvider,
              ),
            );
          },
        );
      },
    );
    return widget.widgets;
  }
}
