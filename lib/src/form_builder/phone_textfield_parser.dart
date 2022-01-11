import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class PhoneTextFieldParser extends WidgetParser {
  /// Returns a [Widget] of type [PhoneTextField]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider? widgetProvider) {
    return PhoneTextFieldCreator(
      map: map,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "phoneNumber"
  @override
  String get widgetName => "phoneNumber";
}

// ignore: must_be_immutable
class PhoneTextFieldCreator extends StatefulWidget implements Manager {
  final Component? map;
  final controller = TextEditingController();
  final WidgetProvider? widgetProvider;
  PhoneTextFieldCreator({this.map, this.widgetProvider});
  @override
  _PhoneTextFieldCreatorState createState() => _PhoneTextFieldCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map!.key;

  /// Current value of the [Widget]
  @override
  get data => controller.text;
}

class _PhoneTextFieldCreatorState extends State<PhoneTextFieldCreator> {
  String characters = "";
  String _calculate = "";
  List<String?> _operators = [];
  List<String> _keys = [];
  final Map<String, dynamic> _mapper = new Map();

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
          _keys.asMap().forEach((value, element) {
            _calculate = (snapshot.data!.containsKey(element))
                ? "$_calculate ${snapshot.data![element]} ${(value < _operators.length) ? (_operators[value]) : ""}"
                : double.tryParse(element) != null
                    ? "$_calculate $element ${(value < _operators.length) ? (_operators[value]) : ""}"
                    : "$_calculate 0 ${(value < _operators.length) ? (_operators[value]) : ""}";
          });
          widget.controller.text = parseCalculate(_calculate);
        }
        if (!isVisible!) widget.controller.text = "";
        return (!isVisible!)
            ? SizedBox.shrink()
            : Neumorphic(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                style: NeumorphicStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                child: TextField(
                  enabled: !widget.map!.disabled!,
                  obscureText: widget.map!.mask!,
                  keyboardType: parsetInputType(widget.map!.type),
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
                  decoration: InputDecoration(
                    counter: (widget.map!.showWordCount != null &&
                            widget.map!.showWordCount!)
                        ? (characters != "")
                            ? Text('${characters.split(' ').length} words')
                            : null
                        : null,
                    prefixText:
                        (widget.map!.prefix != null) ? widget.map!.prefix : "",
                    prefixStyle: TextStyle(
                      background: Paint()..color = Colors.teal[200]!,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                    labelText:
                        (widget.map!.label != null) ? widget.map!.label : "",
                    hintText: widget.map!.label,
                    suffixText:
                        (widget.map!.suffix != null) ? widget.map!.suffix : "",
                    suffixStyle: TextStyle(
                      background: Paint()..color = Colors.teal[200]!,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
