import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// Extends the abstract class [WidgetParser]
class CurrencyTextFieldParser extends WidgetParser {
  /// Returns a [Widget] of type [CurrencyTextField]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return CurrencyTextFieldCreator(
      map: map,
    );
  }

  /// [widgetName] => "currency"
  @override
  String get widgetName => "currency";
}

// ignore: must_be_immutable
class CurrencyTextFieldCreator extends StatefulWidget implements Manager {
  final Component map;
  final controller = TextEditingController();
  WidgetProvider widgetProvider;
  CurrencyTextFieldCreator({this.map});
  @override
  _CurrencyTextFieldCreatorState createState() =>
      _CurrencyTextFieldCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map.key ?? "currencyField";

  /// Current value of the [Widget]
  @override
  get data => controller.text ?? "";
}

class _CurrencyTextFieldCreatorState extends State<CurrencyTextFieldCreator> {
  String characters = "";
  String _calculate = "";
  final Map<String, dynamic> _mapper = new Map();
  String _currency;
  List<String> _operators = [];
  List<String> _keys = [];

  @override
  void initState() {
    super.initState();
    _mapper[widget.map.key] = {""};
    Future.delayed(Duration(milliseconds: 10), () {
      _mapper.update(widget.map.key, (value) => widget.controller.value.text);
      widget.widgetProvider?.registerMap(_mapper);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    /// Declared [WidgetProvider] to consume the [Map<String, dynamic>] created from it.
    widget.widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _currency =
        (widget.map.currency != null) ? currencyCode(widget.map.currency) : "";
    bool isVisible = true;
    if (widget.map.calculateValue != null) {
      _keys = parseListStringCalculated(widget.map.calculateValue);
      _operators = parseListStringOperator(widget.map.calculateValue);
    }
    if (widget.map.defaultValue.isNotEmpty)
      (widget.map.defaultValue is List<String>)
          ? widget.controller.text = widget.map.defaultValue
              .asMap()
              .values
              .toString()
              .replaceAll(RegExp('[()]'), '')
          : widget.controller.text = widget.map.defaultValue.toString();
    return StreamBuilder(
      stream: widget.widgetProvider.widgetsStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        isVisible = (widget.map.conditional != null && snapshot.data != null)
            ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                    snapshot.data[widget.map.conditional.when].toString() ==
                        widget.map.conditional.eq)
                ? widget.map.conditional.show
                : true
            : true;
        if (widget.map.calculateValue != null && snapshot.data != null) {
          _calculate = "";
          _keys.asMap().forEach((value, element) {
            _calculate = (snapshot.data.containsKey(element))
                ? "$_calculate ${snapshot.data[element]} ${(value < _operators.length) ? (_operators[value]) : ""}"
                : "";
          });
          widget.controller.text = parseCalculate(_calculate);
        }
        if (!isVisible) widget.controller.text = "";
        return (!isVisible)
            ? Container()
            : Neumorphic(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                style: NeumorphicStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                child: TextField(
                  enabled: !widget.map.disabled,
                  obscureText: widget.map.mask,
                  keyboardType: parsetInputType(widget.map.type),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  controller: widget.controller,
                  onChanged: (value) {
                    widget.controller.text = (value.contains(_currency))
                        ? value
                        : "$_currency$value";
                    Timer(
                      Duration(milliseconds: 1),
                      () => widget.controller.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: widget.controller.text.length),
                      ),
                    );
                    _mapper.update(widget.map.key, (nVal) => value);
                    widget.widgetProvider.registerMap(_mapper);
                    setState(() {
                      characters = value;
                    });
                  },
                  decoration: InputDecoration(
                    counter: (widget.map.showWordCount != null)
                        ? (characters != "")
                            ? Text(
                                '${characters.replaceAll(' ', '').length} numbers')
                            : Container()
                        : null,
                    prefixText:
                        (widget.map.prefix != null) ? widget.map.prefix : "",
                    prefixStyle: TextStyle(
                      background: Paint()..color = Colors.teal[200],
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                    labelText:
                        (widget.map.label != null) ? widget.map.label : "",
                    hintText: widget.map.label,
                    suffixText:
                        (widget.map.suffix != null) ? widget.map.suffix : "",
                    suffixStyle: TextStyle(
                      background: Paint()..color = Colors.teal[200],
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
