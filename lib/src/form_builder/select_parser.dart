import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';
import 'package:provider/provider.dart';

/// Extends the abstract class [WidgetParser]
class SelectParser extends WidgetParser {
  /// Returns a [Widget] of type [DropDown/Selector]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return SelectParserWidget(map: map);
  }

  /// [widgetName] => "select"
  @override
  String get widgetName => "select";
}

// ignore: must_be_immutable
class SelectParserWidget extends StatefulWidget implements Manager {
  final Component map;
  Value selected;
  WidgetProvider widgetProvider;

  SelectParserWidget({this.map});

  @override
  _SelectParserWidgetState createState() => _SelectParserWidgetState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map.key ?? "selectField";

  /// Current value of the [Widget]
  @override
  get data => selected.value ?? "";
}

class _SelectParserWidgetState extends State<SelectParserWidget> {
  List<DropdownMenuItem<Value>> _values;
  final Map<String, dynamic> _mapper = new Map();

  @override
  void initState() {
    super.initState();
    _values = buildDropDownItems(widget.map.data.values);
    widget.selected = _values[0].value;
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem<Value>> buildDropDownItems(List listItems) {
    List<DropdownMenuItem<Value>> items = List();
    for (Value listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.label),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  void didChangeDependencies() {
    /// Declared [WidgetProvider] to consume the [Map<String, dynamic>] created from it.
    widget.widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _mapper[widget.map.key] = _values[0].value;
    bool isVisible = true;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: StreamBuilder(
          stream: widget.widgetProvider.widgetsStream,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (widget.map.conditional != null)
              isVisible = (widget.map.conditional != null &&
                      snapshot.data != null)
                  ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                          snapshot.data[widget.map.conditional.when]
                                  .toString() ==
                              widget.map.conditional.eq)
                      ? widget.map.conditional.show
                      : true
                  : true;
            return (!isVisible)
                ? Container()
                : (widget.map.neumorphic)
                    ? Neumorphic(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 6.0,
                            ),
                            NeumorphicText(
                              (widget.map.label == null ||
                                      widget.map.label.isEmpty)
                                  ? ""
                                  : widget.map.label,
                              textStyle: NeumorphicTextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w500),
                              style: NeumorphicStyle(
                                  depth: 13.0,
                                  intensity: 0.90,
                                  color: Colors.black),
                            ),
                            DropdownButton<Value>(
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
                                      _mapper.update(
                                          widget.map.key, (nVal) => value);
                                      widget.widgetProvider
                                          .registerMap(_mapper);
                                      setState(() => widget.selected = value);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            (widget.map.label == null ||
                                    widget.map.label.isEmpty)
                                ? ""
                                : widget.map.label,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          DropdownButton<Value>(
                            hint: Text(widget.map.label),
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
                                    _mapper.update(
                                        widget.map.key, (nVal) => value);
                                    widget.widgetProvider.registerMap(_mapper);
                                    setState(() => widget.selected = value);
                                  }
                                : null,
                          ),
                        ],
                      );
          }),
    );
  }
}
