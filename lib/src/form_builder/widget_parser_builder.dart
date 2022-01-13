import 'package:flutter/material.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/abstraction/implements/non_response_click.dart';
import 'package:formio_flutter/src/form_builder/form_builder.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// [WidgetParserBuilder] contains all the logic to build the [hierarchy widgets]
class WidgetParserBuilder {
  /// A [List<WidgetParser>] which contains all the widgets that can be built.
  static final _parsers = [
    ButtonParser(),
    ColumnParser(),
    CheckboxParser(),
    CurrencyTextFieldParser(),
    DateTextFieldParser(),
    DateTimeTextFieldParser(),
    DayTextFieldParser(),
    EmailTextFieldParser(),
    FileParser(),
    LeftIconWidgetParser(),
    NumberTextFieldParser(),
    PagerParser(),
    PhoneTextFieldParser(),
    RightIconWidgetParser(),
    SelectParser(),
    SignatureParser(),
    TextFieldParser(),
    TextAreaParser(),
    TimeTextFieldParser(),
    UrlTextFieldParser(),
  ];

  /// set a [Map<String, WidgetParser]
  static final _widgetNameParserMap = <String, WidgetParser>{};

  /// set a initializer to begin an iteration for each value inside the [List<WidgetParser>]
  static bool _defaultParserInit = false;

  /// List of internal [widgets]
  static List<Widget> _rt = [];

  /// The list of [widgets] that are created.
  static List<Widget> get widgets => _rt;

  /// The length of the current list of [widgets].
  static int get size => _rt.length;

  /// Add to a [Map<String, WidgetParser] the class received from the abstract class [WidgetParser]
  ///
  /// if the key isn't found set a [Container()].
  static void addParser(WidgetParser parser) {
    _parsers.add(parser);
    _widgetNameParserMap[parser.widgetName] = parser;
  }

  /// Initialize the iterator for the widgets to be added
  static void initDefaultParsersIfNess() {
    /// check if this has been already initialized.
    if (!_defaultParserInit) {
      for (var parser in _parsers) {
        _widgetNameParserMap[parser.widgetName] = parser;
      }
      _defaultParserInit = true;
    }
  }

  /// Returns a [Widget] from each [WidgetParser] that match the [widgetName] with the [type] attribute.
  static Widget build(Component components, BuildContext context,
      ClickListener? listener, FormioWidgetProvider? widgetProvider) {
    initDefaultParsersIfNess();
    ClickListener _listener =
        listener == null ? new NonResponseWidgetClickListener() : listener;
    return buildFromMap(components, context, _listener, widgetProvider);
  }

  /// Same as [build] but this returns the [WidgetParser] child class that has been found.
  static Widget buildFromMap(Component component, BuildContext context,
      ClickListener listener, FormioWidgetProvider? widgetProvider) {
    var parser = _widgetNameParserMap[component.type!];
    return (parser != null)
        ? parser.parse(component, context, listener, widgetProvider)
        : Container();
  }

  /// Returns a [List<Widget>] represented by the data found inside the function [build]
  static List<Widget> buildWidgetsByComponent(
      List<Component> components,
      BuildContext context,
      ClickListener? listener,
      FormioWidgetProvider? widgetProvider) {
    _rt = [];
    if (components.isEmpty) return [];
    components.asMap().forEach((key, value) {
      _rt.add(build(value, context, listener, widgetProvider));
    });
    return _rt;
  }

  /// Same as [buildWidgetsByComponent], but used the [FormCollection] as the root.
  static List<Widget> buildWidgets(
      FormCollection collection,
      BuildContext context,
      ClickListener listener,
      FormioWidgetProvider widgetProvider) {
    _rt = [];
    if (collection.components!.isEmpty) return [];
    collection.components!.forEach((element) {
      _rt.add(build(element, context, listener, widgetProvider));
    });
    return _rt;
  }
}
