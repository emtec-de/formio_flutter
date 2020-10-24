import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

class CheckboxParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return CheckboxCreator(
      map: map,
    );
  }

  @override
  String get widgetName => "checkbox";
}

// ignore: must_be_immutable
class CheckboxCreator extends StatefulWidget implements Manager {
  final Component map;
  bool isSelected;
  WidgetProvider widgetProvider;
  CheckboxCreator({this.map});
  @override
  _CheckboxCreatorState createState() => _CheckboxCreatorState();

  @override
  String keyValue() => map.key ?? "checkbox";

  @override
  get data => isSelected;
}

class _CheckboxCreatorState extends State<CheckboxCreator> {
  String characters = "";
  final Map<String, dynamic> _mapper = new Map();

  @override
  void initState() {
    super.initState();
    widget.isSelected = (widget.map.defaultValue as bool);
    _mapper[widget.map.key] = widget.isSelected;
    Future.delayed(Duration(milliseconds: 10), () {
      widget.widgetProvider?.registerMap(_mapper);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    widget.widgetProvider = Provider.of<WidgetProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = true;
    return (!widget.map.disabled)
        ? StreamBuilder(
            stream: widget.widgetProvider.widgetsStream,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                  : CheckboxListTile(
                      title: Text(
                        (widget.map.label != null) ? widget.map.label : "",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      value: widget.isSelected,
                      onChanged: (value) {
                        setState(() => widget.isSelected = value);
                        _mapper.update(widget.map.key, (t) => value);
                        widget.widgetProvider.registerMap(_mapper);
                      },
                    );
            })
        : Container();
  }
}
