import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class TimeTextFieldParser extends WidgetParser {
  /// Returns a [Widget] of type [TimeTextField]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      FormioWidgetProvider? widgetProvider) {
    return TimeTextFieldCreator(
      map: map,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "time"
  @override
  String get widgetName => "time";
}

// ignore: must_be_immutable
class TimeTextFieldCreator extends StatefulWidget implements Manager {
  final Component? map;
  final controller = TextEditingController();
  final FormioWidgetProvider? widgetProvider;
  TimeTextFieldCreator({this.map, this.widgetProvider});
  @override
  _TimeTextFieldCreatorState createState() => _TimeTextFieldCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String? keyValue() => map!.key;

  /// Current value of the [Widget]
  @override
  get data => controller.text;
}

class _TimeTextFieldCreatorState extends State<TimeTextFieldCreator> {
  String characters = "";
  final Map<String?, dynamic> _mapper = new Map();

  @override
  void initState() {
    super.initState();
    _mapper[widget.map!.key] = {""};
    if (widget.map!.defaultValue != null) if (widget
        .map!.defaultValue.isNotEmpty)
      (widget.map!.defaultValue is List<String>)
          ? widget.controller.text = widget.map!.defaultValue
              .asMap()
              .values
              .toString()
              .replaceAll(RegExp('[()]'), '')
          : widget.controller.text = widget.map!.defaultValue.toString();
    widget.controller.addListener(() {
      _mapper.update(widget.map!.key, (value) => widget.controller.value.text);
    });
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
    /// Declared [WidgetProvider] to consume the [Map<String, dynamic>] created from it.
    final size = MediaQuery.of(context).size;
    bool? isVisible = true;
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
                child: Container(
                  width: (size.width * 0.5),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    enabled: !widget.map!.disabled!,
                    obscureText: widget.map!.mask!,
                    keyboardType: parsetInputType(widget.map!.type),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    controller: widget.controller,
                    enableInteractiveSelection: false,
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
                      prefixText: (widget.map!.prefix != null)
                          ? widget.map!.prefix
                          : "",
                      prefixStyle: TextStyle(
                        background: Paint()..color = Colors.teal[200]!,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                      labelText:
                          (widget.map!.label != null) ? widget.map!.label : "",
                      hintText: widget.map!.label,
                      icon: Icon(Icons.timer),
                      suffixText: (widget.map!.suffix != null)
                          ? widget.map!.suffix
                          : "",
                      suffixStyle: TextStyle(
                        background: Paint()..color = Colors.teal[200]!,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectTime(context);
                    },
                  ),
                ),
              );
      },
    );
  }

  _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );
    if (picked != null) {
      var time =
          "${picked.hour}:${picked.minute} ${(picked.period == DayPeriod.am) ? "am" : "pm"}";
      _mapper.update(widget.map!.key, (value) => time);
      widget.widgetProvider!.widgetBloc.registerMap(_mapper);
      setState(() => widget.controller.text = time);
    }
  }
}
