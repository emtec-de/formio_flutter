import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// Extends the abstract class [WidgetParser]
class SelectParser extends WidgetParser {
  /// Returns a [Widget] of type [DropDown/Selector]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider widgetProvider) {
    return SelectParserWidget(map: map, widgetProvider: widgetProvider);
  }

  /// [widgetName] => "select"
  @override
  String get widgetName => "select";
}

// ignore: must_be_immutable
class SelectParserWidget extends StatefulWidget implements Manager {
  final Component map;
  Value selected;
  final WidgetProvider widgetProvider;

  SelectParserWidget({this.map, this.widgetProvider});

  @override
  _SelectParserWidgetState createState() => _SelectParserWidgetState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map.key ?? "selectField";

  /// Current value of the [Widget]
  @override
  get data => selected != null ? selected.toMap() : "";
}

class _SelectParserWidgetState extends State<SelectParserWidget> {
  List<DropdownMenuItem<Value>> _values;
  Future<List<Value>> _futureValues;
  final Map<String, dynamic> _mapper = new Map();

  /// When the [url] isn't null or empty then the data is prefetched for the [Select] widget.
  Future<List<Value>> _makeRequest() async {
    var client = http.Client();
    final response = await client.get(widget.map.data.url);
    final result = Value().valuesFromJson(response.body);
    if (result.isNotEmpty) {
      setupDropDown(result);
      _mapper[widget.map.key] = result.first.value;
      widget.widgetProvider.widgetBloc.registerMap(_mapper);
    }
    return result;
  }

  /// Setup all the functionality for the dropDown widget.
  setupDropDown(List<Value> values) {
    _values = buildDropDownItems(values);
    if (widget.map.defaultValue != null && widget.map.defaultValue != "") {
      int _position = 0;
      if (widget.map.defaultValue is Map<String, dynamic>) {
        _position = values.indexWhere(
            (element) => element.value == widget.map.defaultValue['value']);
      } else if (widget.map.defaultValue is String) {
        _position = values
            .indexWhere((element) => element.value == widget.map.defaultValue);
      }
      widget.selected =
          (_position == -1) ? _values[0].value : _values[_position].value;
    } else {
      widget.selected = _values.first.value;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.map.data.url.isEmpty &&
        widget.map.data.values.isNotEmpty &&
        widget.map.data.values.first.value != null) {
      setupDropDown(widget.map.data.values);
      _mapper[widget.map.key] = _values[0].value.value;
      Future.delayed(
        Duration(milliseconds: 10),
        () => widget.widgetProvider.widgetBloc.registerMap(_mapper),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem<Value>> buildDropDownItems(List listItems) {
    List<DropdownMenuItem<Value>> items = List();
    if (listItems == null ||
        listItems[0] == null ||
        (listItems[0] as Value).value == null) {
      items.add(DropdownMenuItem(
        child: Text('Empty'),
        value: null,
      ));
    } else {
      for (Value listItem in listItems) {
        items.add(
          DropdownMenuItem(
            child: Text(listItem.label),
            value: listItem,
          ),
        );
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.map.data.url.isNotEmpty) _futureValues ??= _makeRequest();
    bool isVisible = true;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: StreamBuilder(
        stream: widget.widgetProvider.widgetBloc.widgetsStream,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (widget.map.conditional != null)
            isVisible = (widget.map.conditional != null &&
                    snapshot.data != null)
                ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                        snapshot.data[widget.map.conditional.when].toString() ==
                            widget.map.conditional.eq)
                    ? widget.map.conditional.show
                    : !widget.map.conditional.show
                : true;
          return (!isVisible)
              ? SizedBox.shrink()
              : Neumorphic(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NeumorphicText(
                        (widget.map.label == null || widget.map.label.isEmpty)
                            ? ""
                            : widget.map.label,
                        textStyle: NeumorphicTextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.w500),
                        style: NeumorphicStyle(
                            depth: 13.0, intensity: 0.90, color: Colors.black),
                      ),
                      (widget.map.data.url.isNotEmpty)
                          ? FutureBuilder(
                              future: _futureValues,
                              builder: (context,
                                  AsyncSnapshot<List<Value>> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    return DropdownButton<Value>(
                                      hint: NeumorphicText(
                                        widget.map.label,
                                        style: NeumorphicStyle(
                                            depth: 13.0,
                                            intensity: 0.90,
                                            color: Colors.black),
                                      ),
                                      isExpanded: true,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                      value: widget.selected,
                                      items: _values,
                                      onChanged: !widget.map.disabled
                                          ? (value) {
                                              _mapper.update(widget.map.key,
                                                  (nVal) => value.value);
                                              widget.widgetProvider.widgetBloc
                                                  .registerMap(_mapper);
                                              setState(() =>
                                                  widget.selected = value);
                                            }
                                          : null,
                                    );
                                    break;
                                  default:
                                    return CircularProgressIndicator();
                                    break;
                                }
                              },
                            )
                          : (widget.map.data.values.isNotEmpty &&
                                  widget.map.data.values.first.value != null)
                              ? DropdownButton<Value>(
                                  hint: NeumorphicText(
                                    widget.map.label,
                                    style: NeumorphicStyle(
                                        depth: 13.0,
                                        intensity: 0.90,
                                        color: Colors.black),
                                  ),
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  value: widget.selected,
                                  items: _values,
                                  onChanged: !widget.map.disabled
                                      ? (value) {
                                          _mapper.update(widget.map.key,
                                              (nVal) => value.value);
                                          widget.widgetProvider.widgetBloc
                                              .registerMap(_mapper);
                                          setState(
                                              () => widget.selected = value);
                                        }
                                      : null,
                                )
                              : DropdownButton<Value>(
                                  hint: NeumorphicText(
                                    widget.map.label,
                                    style: NeumorphicStyle(
                                        depth: 13.0,
                                        intensity: 0.90,
                                        color: Colors.black),
                                  ),
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  value: widget.selected,
                                  items: _values,
                                  onChanged: !widget.map.disabled
                                      ? (value) {
                                          _mapper.update(widget.map.key,
                                              (nVal) => value.value);
                                          widget.widgetProvider.widgetBloc
                                              .registerMap(_mapper);
                                          setState(
                                              () => widget.selected = value);
                                        }
                                      : null,
                                ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
