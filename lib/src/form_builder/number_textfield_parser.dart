import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class NumberTextFieldParser extends WidgetParser {
  /// Returns a [Widget] of type [NumberTextField]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider widgetProvider) {
    return NumberTextFieldCreator(
      map: map,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "number"
  @override
  String get widgetName => "number";
}

// ignore: must_be_immutable
class NumberTextFieldCreator extends StatefulWidget implements Manager {
  final Component map;
  final controller = TextEditingController();
  final WidgetProvider widgetProvider;
  NumberTextFieldCreator({this.map, this.widgetProvider});
  @override
  _NumberTextFieldCreatorState createState() => _NumberTextFieldCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map.key ?? "numberField";

  /// Current value of the [Widget]
  @override
  get data => controller.text ?? "";
}

class _NumberTextFieldCreatorState extends State<NumberTextFieldCreator> {
  String characters = "";
  String _calculate = "";
  final Map<String, dynamic> _mapper = new Map();
  List<String> _operators = [];
  List<String> _keys = [];

  bool _error;
  String _errorText;

  @override
  void initState() {
    super.initState();

    _error = false;
    _errorText = '';

    _mapper[widget.map.key] = {""};
    if (widget.map.defaultValue != null)
      (widget.map.defaultValue is List<String>)
          ? widget.controller.text = widget.map.defaultValue
              .asMap()
              .values
              .toString()
              .replaceAll(RegExp('[()]'), '')
          : widget.controller.text = (widget.map.defaultValue != "")
              ? double.parse(widget.map.defaultValue.toString())
                  .toStringAsFixed(widget.map.decimalLimit)
              : "";
    widget.controller.addListener(() {
      _mapper.update(widget.map.key, (value) => widget.controller.value.text);
    });
    Future.delayed(Duration(milliseconds: 10), () {
      _mapper.update(widget.map.key, (value) => widget.controller.value.text);
      widget.widgetProvider.widgetBloc.registerMap(_mapper);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color parseRgb(String input) {
    var startIndex = input.indexOf("(") + 1;
    var endIndex = input.indexOf(")");
    var values = input
        .substring(startIndex, endIndex)
        .split(",")
        .map((v) => int.parse(v));
    return Color.fromARGB(
        255, values.elementAt(0), values.elementAt(1), values.elementAt(2));
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = true;
    final size = MediaQuery.of(context).size;
    if (widget.map.calculateValue != null) {
      _keys = parseListStringCalculated(widget.map.calculateValue);
      _operators = parseListStringOperator(widget.map.calculateValue);
    }
    return StreamBuilder(
      stream: widget.widgetProvider.widgetBloc.widgetsStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        isVisible = (widget.map.conditional != null && snapshot.data != null)
            ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                    snapshot.data[widget.map.conditional.when].toString() ==
                        widget.map.conditional.eq)
                ? widget.map.conditional.show
                : !widget.map.conditional.show
            : true;
        if (widget.map.calculateValue != null &&
            widget.map.calculateValue.isNotEmpty &&
            snapshot.data != null) {
          _calculate = "";
          _keys.asMap().forEach((value, element) {
            _calculate = (snapshot.data.containsKey(element))
                ? "$_calculate ${snapshot.data[element]} ${(value < _operators.length) ? (_operators[value]) : ""}"
                : double.tryParse(element) != null
                    ? "$_calculate $element ${(value < _operators.length) ? (_operators[value]) : ""}"
                    : "$_calculate 0 ${(value < _operators.length) ? (_operators[value]) : ""}";
          });
          widget.controller.text =
              double.tryParse(parseCalculate(_calculate)) == null
                  ? ""
                  : double.parse(parseCalculate(_calculate))
                      .toStringAsFixed(widget.map.decimalLimit);
        }
        if (!isVisible) widget.controller.text = "";
        return (!isVisible)
            ? SizedBox.shrink()
            : (widget.map.total != 0)
                ? Container(
                    //width: (size.width * (1 / (widget.map.total + 0.5))),
                    width: (size.width * 0.5),
                    margin: widget.map.marginData != null
                        ? EdgeInsets.only(
                            top: widget.map.marginData.top != null
                                ? widget.map.marginData.top
                                : 0.0,
                            left: widget.map.marginData.left != null
                                ? widget.map.marginData.left
                                : 0.0,
                            right: widget.map.marginData.right != null
                                ? widget.map.marginData.right
                                : 0.0,
                            bottom: widget.map.marginData.bottom != null
                                ? widget.map.marginData.bottom
                                : 0.0,
                          )
                        : EdgeInsets.all(0.0),
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.map.borderData != null &&
                                widget.map.borderData.lableInBorder != null &&
                                !(widget.map.borderData.lableInBorder)
                            ? Text(
                                (widget.map.label == null ||
                                        widget.map.label.isEmpty)
                                    ? ""
                                    : widget.map.label,
                                style: TextStyle(
                                  fontSize: widget.map.textStyleData != null &&
                                          widget.map.textStyleData.fontSize !=
                                              null
                                      ? widget.map.textStyleData.fontSize
                                      : 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : SizedBox.shrink(),
                        widget.map.borderData != null &&
                                widget.map.borderData.lableInBorder != null &&
                                !(widget.map.borderData.lableInBorder)
                            ? SizedBox(height: 6)
                            : SizedBox.shrink(),
                        TextField(
                          enabled: !widget.map.disabled,
                          obscureText: widget.map.mask,
                          keyboardType: parsetInputType(widget.map.type),
                          style: widget.map.textStyleData == null
                              ? TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                )
                              : TextStyle(
                                  fontSize:
                                      widget.map.textStyleData.fontSize == null
                                          ? 15.0
                                          : widget.map.textStyleData.fontSize,
                                  color: widget.map.textStyleData.color == null
                                      ? Colors.black
                                      : parseRgb(
                                          widget.map.textStyleData.color),
                                  fontWeight:
                                      widget.map.textStyleData.fontWeight ==
                                              null
                                          ? FontWeight.w400
                                          : FontWeight.w400,
                                  // : parseFontWeight(
                                  // widget.map.textStyleData.fontWeight,
                                  // ),
                                ),
                          controller: widget.controller,
                          onChanged: (value) {
                            value = (value != "")
                                ? double.parse(parseCalculate(value))
                                    .toStringAsFixed(widget.map.decimalLimit)
                                : value;
                            _mapper.update(widget.map.key, (nVal) => value);
                            widget.widgetProvider.widgetBloc
                                .registerMap(_mapper);
                            setState(() => characters = value);
                            if (value.trim().isEmpty && widget.map.errorOnEmpty)
                              setState(() {
                                _error = true;
                                _errorText = '${widget.map.errorText}';
                              });
                            else
                              setState(() => _error = false);
                          },
                          onSubmitted: (String value) {
                            if (value.trim().isEmpty && widget.map.errorOnEmpty)
                              setState(() {
                                _error = true;
                                _errorText = '${widget.map.errorText}';
                              });
                            else
                              setState(() => _error = false);
                          },
                          decoration: InputDecoration(
                            labelText: (widget.map.label != null)
                                ? widget.map.label
                                : "",
                            hintText:
                                widget.map.hint != null ? widget.map.hint : "",
                            errorText: _error ? "$_errorText" : null,
                            border: widget.map.borderData != null
                                ? OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      widget.map.borderData.borderRadius,
                                    ),
                                    borderSide: BorderSide(
                                      color: parseRgb(
                                        widget.map.borderData.borderColor,
                                      ),
                                      width: widget.map.borderData.borderWidth,
                                    ),
                                  )
                                : InputBorder.none,
                            counter: (widget.map.showWordCount != null &&
                                    widget.map.showWordCount)
                                ? null
                                : SizedBox.shrink(),
                            prefixIcon: widget.map.leftIcon != null
                                ? LeftIconWidgetParser(
                                    color: widget.map.leftIconColor != null
                                        ? parseRgb(widget.map.leftIconColor)
                                        : Colors.black,
                                  ).parse(
                                    widget.map,
                                    context,
                                    null,
                                    null,
                                  )
                                : Container(),
                            // suffixIcon: widget.map.rightIcon != null
                            //     ? RightIconWidgetParser(
                            //         color: widget.map.rightIconColor != null
                            //             ? parseRgb(widget.map.rightIconColor)
                            //             : Colors.black,
                            //       ).parse(
                            //         widget.map,
                            //         context,
                            //         null,
                            //         null,
                            //       )
                            //     : Container(),
                            // prefixText: (widget.map.prefix != null)
                            //     ? widget.map.prefix
                            //     : "",
                            // prefixStyle: TextStyle(
                            //   background: Paint()..color = Colors.teal[200],
                            //   color: Colors.black,
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 20.0,
                            // ),
                            // suffixText: (widget.map.suffix != null)
                            //     ? widget.map.suffix
                            //     : "",
                            // suffixStyle: TextStyle(
                            //   background: Paint()..color = Colors.teal[200],
                            //   color: Colors.black,
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 20.0,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: widget.map.marginData != null
                        ? EdgeInsets.only(
                            top: widget.map.marginData.top != null
                                ? widget.map.marginData.top
                                : 0.0,
                            left: widget.map.marginData.left != null
                                ? widget.map.marginData.left
                                : 0.0,
                            right: widget.map.marginData.right != null
                                ? widget.map.marginData.right
                                : 0.0,
                            bottom: widget.map.marginData.bottom != null
                                ? widget.map.marginData.bottom
                                : 0.0,
                          )
                        : EdgeInsets.all(0.0),
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.map.borderData != null &&
                                widget.map.borderData.lableInBorder != null &&
                                !(widget.map.borderData.lableInBorder)
                            ? Text(
                                (widget.map.label == null ||
                                        widget.map.label.isEmpty)
                                    ? ""
                                    : widget.map.label,
                                style: TextStyle(
                                  fontSize: widget.map.textStyleData != null &&
                                          widget.map.textStyleData.fontSize !=
                                              null
                                      ? widget.map.textStyleData.fontSize
                                      : 17.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : SizedBox.shrink(),
                        widget.map.borderData != null &&
                                widget.map.borderData.lableInBorder != null &&
                                !(widget.map.borderData.lableInBorder)
                            ? SizedBox(height: 6)
                            : SizedBox.shrink(),
                        TextField(
                          enabled: !widget.map.disabled,
                          obscureText: widget.map.mask,
                          keyboardType: parsetInputType(widget.map.type),
                          style: widget.map.textStyleData == null
                              ? TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                )
                              : TextStyle(
                                  fontSize:
                                      widget.map.textStyleData.fontSize == null
                                          ? 15.0
                                          : widget.map.textStyleData.fontSize,
                                  color: widget.map.textStyleData.color == null
                                      ? Colors.black
                                      : parseRgb(
                                          widget.map.textStyleData.color),
                                  fontWeight:
                                      widget.map.textStyleData.fontWeight ==
                                              null
                                          ? FontWeight.w400
                                          : FontWeight.w400,
                                  // : parseFontWeight(
                                  // widget.map.textStyleData.fontWeight,
                                  // ),
                                ),
                          controller: widget.controller,
                          onChanged: (value) {
                            value = double.parse(parseCalculate(value))
                                .toStringAsFixed(widget.map.decimalLimit);
                            _mapper.update(widget.map.key, (nVal) => value);
                            widget.widgetProvider.widgetBloc
                                .registerMap(_mapper);
                            setState(() => characters = value);
                            if (value.trim().isEmpty && widget.map.errorOnEmpty)
                              setState(() {
                                _error = true;
                                _errorText = '${widget.map.errorText}';
                              });
                            else
                              setState(() => _error = false);
                          },
                          onSubmitted: (String value) {
                            if (value.trim().isEmpty && widget.map.errorOnEmpty)
                              setState(() {
                                _error = true;
                                _errorText = '${widget.map.errorText}';
                              });
                            else
                              setState(() => _error = false);
                          },
                          decoration: InputDecoration(
                            labelText: (widget.map.label != null)
                                ? widget.map.label
                                : "",
                            hintText:
                                widget.map.hint != null ? widget.map.hint : "",
                            errorText: _error ? "$_errorText" : null,
                            border: widget.map.borderData != null
                                ? OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      widget.map.borderData.borderRadius,
                                    ),
                                    borderSide: BorderSide(
                                      color: parseRgb(
                                        widget.map.borderData.borderColor,
                                      ),
                                      width: widget.map.borderData.borderWidth,
                                    ),
                                  )
                                : InputBorder.none,
                            counter: (widget.map.showWordCount != null &&
                                    widget.map.showWordCount)
                                ? null
                                : SizedBox.shrink(),
                            prefixIcon: widget.map.leftIcon != null
                                ? LeftIconWidgetParser(
                                    color: widget.map.leftIconColor != null
                                        ? parseRgb(widget.map.leftIconColor)
                                        : Colors.black,
                                  ).parse(
                                    widget.map,
                                    context,
                                    null,
                                    null,
                                  )
                                : Container(),
                            // suffixIcon: widget.map.rightIcon != null
                            //     ? RightIconWidgetParser(
                            //         color: widget.map.rightIconColor != null
                            //             ? parseRgb(widget.map.rightIconColor)
                            //             : Colors.black,
                            //       ).parse(
                            //         widget.map,
                            //         context,
                            //         null,
                            //         null,
                            //       )
                            //     : Container(),
                            // prefixText: (widget.map.prefix != null)
                            //     ? widget.map.prefix
                            //     : "",
                            // prefixStyle: TextStyle(
                            //   background: Paint()..color = Colors.teal[200],
                            //   color: Colors.black,
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 20.0,
                            // ),
                            // suffixText: (widget.map.suffix != null)
                            //     ? widget.map.suffix
                            //     : "",
                            // suffixStyle: TextStyle(
                            //   background: Paint()..color = Colors.teal[200],
                            //   color: Colors.black,
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 20.0,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  );
      },
    );
  }
}
