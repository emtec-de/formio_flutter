import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class TextAreaParser extends WidgetParser {
  /// Returns a [Widget] of type [TextArea]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      FormioWidgetProvider? widgetProvider) {
    return TextAreaCreator(
      map: map,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "textarea"
  @override
  String get widgetName => "textarea";
}

class TextAreaCreator extends StatefulWidget implements Manager {
  final Component? map;
  final FormioWidgetProvider? widgetProvider;
  final controller = TextEditingController();
  TextAreaCreator({this.map, this.widgetProvider});
  @override
  _TextAreaCreatorState createState() => _TextAreaCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String? keyValue() => map!.key;

  /// Current value of the [Widget]
  @override
  get data => controller.text;
}

class _TextAreaCreatorState extends State<TextAreaCreator> {
  String characters = "";
  String _calculate = "";
  List<String?> _operators = [];
  List<String> _keys = [];
  final Map<String?, dynamic> _mapper = new Map();

  @override
  void initState() {
    super.initState();
    _mapper[widget.map!.key] = {""};
    if (widget.map!.defaultValue != null)
      (widget.map!.defaultValue is List<String>)
          ? widget.controller.text = widget.map!.defaultValue
              .asMap()
              .values
              .toString()
              .replaceAll(RegExp('[()]'), '')
          : widget.controller.text = widget.map!.defaultValue.toString();
    Future.delayed(Duration(milliseconds: 10), () {
      _mapper.update(widget.map!.key, (value) => widget.controller.value.text);
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
    final size = MediaQuery.of(context).size;
    if (widget.map!.calculateValue != null) {
      _keys = parseListStringCalculated(widget.map!.calculateValue!);
      _operators = parseListStringOperator(widget.map!.calculateValue!);
    }
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

        if (widget.map!.calculateValue != null &&
            widget.map!.calculateValue!.isNotEmpty &&
            snapshot.data != null) {
          _calculate = "";
          _keys.asMap().forEach(
            (value, element) {
              _calculate = (snapshot.data!.containsKey(element))
                  ? "$_calculate ${snapshot.data![element]} ${(value < _operators.length) ? (_operators[value]) : ""}"
                  : double.tryParse(element) != null
                      ? "$_calculate $element ${(value < _operators.length) ? (_operators[value]) : ""}"
                      : "$_calculate 0 ${(value < _operators.length) ? (_operators[value]) : ""}";
            },
          );
          widget.controller.text = parseCalculate(_calculate);
        }
        if (!isVisible!) widget.controller.text = "";
        return (!isVisible!)
            ? SizedBox.shrink()
            : Neumorphic(
                child: Container(
                  //width: (size.width * (1 / (widget.map.total + 0.5))),
                  width: (size.width * 0.5),
                  height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    enabled: !widget.map!.disabled!,
                    obscureText: widget.map!.mask!,
                    keyboardType: parsetInputType(widget.map!.type),
                    maxLines: 8,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    controller: widget.controller,
                    onChanged: (value) {
                      _mapper.update(widget.map!.key, (nVal) => value);
                      widget.widgetProvider!.widgetBloc.registerMap(_mapper);
                      setState(() => characters = value);
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: widget.map!.label,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
