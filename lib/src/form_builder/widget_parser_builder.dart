import 'package:flutter/material.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';

class WidgetParserBuilder {
  static final _parsers = [
    ColumnParser(),
    ButtonParser(),
    CheckboxParser(),
    LeftIconWidgetParser(),
    RightIconWidgetParser(),
    TextFieldParser(),
    TextAreaParser(),
    EmailTextFieldParser(),
    PhoneTextFieldParser(),
    DateTextFieldParser(),
    TimeTextFieldParser(),
    UrlTextFieldParser(),
    NumberTextFieldParser(),
    SelectParser(),
    SignatureParser(),
    FileParser(),
    PagerParser(),
  ];

  static final _widgetNameParserMap = <String, WidgetParser>{};
  static bool _defaultParserInited = false;

  static void addParser(WidgetParser parser) {
    _parsers.add(parser);
    _widgetNameParserMap[parser.widgetName] = parser;
  }

  static void initDefaultParsersIfNess() {
    if (!_defaultParserInited) {
      for (var parser in _parsers) {
        _widgetNameParserMap[parser.widgetName] = parser;
      }
      _defaultParserInited = true;
    }
  }

  static Widget build(
      Component components, BuildContext context, ClickListener listener) {
    initDefaultParsersIfNess();
    ClickListener _listener =
        listener == null ? new NonResponseWidgetClickListener() : listener;
    return buildFromMap(components, context, _listener);
  }

  static Widget buildFromMap(
      Component component, BuildContext context, ClickListener listener) {
    var parser = _widgetNameParserMap[component.type];
    return (parser != null)
        ? parser.parse(component, context, listener)
        : Container();
  }

  static List<Widget> buildWidgetsByComponent(List<Component> components,
      BuildContext context, ClickListener listener) {
    List<Widget> rt = [];
    if (components.isEmpty) return [];
    components.asMap().forEach((key, value) {
      rt.add(build(value, context, listener));
    });
    return rt;
  }

  static List<Widget> buildWidgets(
      FormCollection collection, BuildContext context, ClickListener listener) {
    List<Widget> rt = [];
    collection.components.forEach((element) {
      rt.add(build(element, context, listener));
    });
    return rt;
  }
}
