import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class CheckboxParser extends WidgetParser {
  /// Returns a [Widget] of type [Checkbox]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      FormioWidgetProvider? widgetProvider) {
    return CheckboxCreator(
      map: map,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "checkbox"
  @override
  String get widgetName => "checkbox";
}

// ignore: must_be_immutable
class CheckboxCreator extends StatefulWidget implements Manager {
  final Component? map;
  bool? isSelected;
  final FormioWidgetProvider? widgetProvider;
  CheckboxCreator({
    this.map,
    this.widgetProvider,
  });
  @override
  _CheckboxCreatorState createState() => _CheckboxCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String? keyValue() => map!.key;

  /// Current value of the [Widget]
  @override
  get data => isSelected;
}

class _CheckboxCreatorState extends State<CheckboxCreator> {
  String characters = "";
  final Map<String?, dynamic> _mapper = new Map();

  @override
  void initState() {
    super.initState();
    widget.isSelected = (widget.map!.defaultValue is bool)
        ? widget.map!.defaultValue ?? false
        : false;
    _mapper[widget.map!.key] = widget.isSelected;
    Future.delayed(Duration(milliseconds: 10), () {
      widget.widgetProvider!.widgetBloc.registerMap(_mapper);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool? isVisible = true;
    return (!widget.map!.disabled!)
        ? StreamBuilder(
            stream: widget.widgetProvider!.widgetBloc.widgetsStream,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              isVisible =
                  (widget.map!.conditional != null && snapshot.data != null)
                      ? (snapshot.data!
                                  .containsKey(widget.map!.conditional!.when) &&
                              snapshot.data![widget.map!.conditional!.when]
                                      .toString() ==
                                  widget.map!.conditional!.eq)
                          ? widget.map!.conditional!.show
                          : !widget.map!.conditional!.show!
                      : true;
              return (!isVisible!)
                  ? SizedBox.shrink()
                  : Container(
                      margin: widget.map!.marginData != null
                          ? EdgeInsets.only(
                              top: widget.map!.marginData!.top!,
                              left: widget.map!.marginData!.left!,
                              right: widget.map!.marginData!.right!,
                              bottom: widget.map!.marginData!.bottom!,
                            )
                          : EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              (widget.map!.label != null)
                                  ? widget.map!.label!
                                  : "",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 7.0),
                          Checkbox(
                            value: widget.isSelected,
                            onChanged: (value) {
                              setState(() => widget.isSelected = value);
                              _mapper.update(widget.map!.key, (t) => value);
                              widget.widgetProvider!.widgetBloc
                                  .registerMap(_mapper);
                            },
                          ),
                        ],
                      ),
                    );
            },
          )
        : Container();
  }
}
