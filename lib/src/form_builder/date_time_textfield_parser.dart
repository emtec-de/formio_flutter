import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// Extends the abstract class [WidgetParser]
class DateTimeTextFieldParser extends WidgetParser {
  /// Returns a [Widget] of type [DateTimeTextField]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return DateTimeTextFieldCreator(
      map: map,
    );
  }

  /// [widgetName] => "datetime"
  @override
  String get widgetName => "datetime";
}

// ignore: must_be_immutable
class DateTimeTextFieldCreator extends StatefulWidget implements Manager {
  final Component map;
  final controller = TextEditingController();
  WidgetProvider widgetProvider;
  DateTimeTextFieldCreator({this.map});
  @override
  _DateTimeTextFieldCreatorState createState() =>
      _DateTimeTextFieldCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map.key ?? "datetime";

  /// Current value of the [Widget]
  @override
  get data => controller.text ?? "";
}

class _DateTimeTextFieldCreatorState extends State<DateTimeTextFieldCreator> {
  final _dateFormat = DateFormat('yyyy-MM-d');
  final Map<String, dynamic> _mapper = new Map();
  String characters = "";
  String selectedDT = "";

  @override
  void initState() {
    super.initState();
    _mapper[widget.map.key] = {""};
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
    bool isVisible = true;
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
          if (!isVisible) widget.controller.text = "";
          return (!isVisible)
              ? Container()
              : TextField(
                  enabled: !widget.map.disabled,
                  obscureText: widget.map.mask,
                  keyboardType: parsetInputType(widget.map.type),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  controller: widget.controller,
                  enableInteractiveSelection: false,
                  onChanged: (value) {
                    _mapper.update(widget.map.key, (nVal) => value);
                    widget.widgetProvider.registerMap(_mapper);
                    setState(() {
                      characters = value;
                    });
                  },
                  decoration: InputDecoration(
                    counter: (widget.map.showWordCount != null)
                        ? (characters != "")
                            ? Text('${characters.split(' ').length} words')
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
                    icon: Icon(Icons.calendar_today),
                    suffixText:
                        (widget.map.suffix != null) ? widget.map.suffix : "",
                    suffixStyle: TextStyle(
                      background: Paint()..color = Colors.teal[200],
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  },
                );
        });
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2100),
    );
    if (picked != null) {
      selectedDT = _dateFormat.format(picked);
      await _selectTime(context);
    }
  }

  _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );
    if (picked != null) {
      setState(() {
        selectedDT =
            "$selectedDT ${picked.hour}:${picked.minute} ${(picked.period == DayPeriod.am) ? "am" : "pm"}";
        widget.controller.text = selectedDT;
      });
    }
  }
}
