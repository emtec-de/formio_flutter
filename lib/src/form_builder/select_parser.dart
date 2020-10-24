import 'package:flutter/material.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';
import 'package:provider/provider.dart';

class SelectParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return SelectParserWidget(map: map);
  }

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

  @override
  String keyValue() => map.key ?? "selectField";

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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        (widget.map.label == null || widget.map.label.isEmpty)
                            ? ""
                            : widget.map.label,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      DropdownButton<Value>(
                        hint: Text(widget.map.label),
                        isExpanded: true,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        value: widget.selected,
                        items: _values,
                        onChanged: !widget.map.disabled
                            ? (value) {
                                _mapper.update(widget.map.key, (nVal) => value);
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
