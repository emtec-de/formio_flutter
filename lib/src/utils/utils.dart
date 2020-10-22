import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:math_expressions/math_expressions.dart';

Map<String, dynamic> map = new Map();
RegExp regex = new RegExp("(?!^-)[+*\/-](\s?-)?");
bool result = false;

const Map<String, int> colorMap = {
  'aqua': 0x00FFFF,
  'black': 0x000000,
  'blue': 0x0000FF,
  'brown': 0x9A6324,
  'cream': 0xFFFDD0,
  'cyan': 0x46f0f0,
  'green': 0x00FF00,
  'gray': 0x808080,
  'grey': 0x808080,
  'mint': 0xAAFFC3,
  'lavender': 0xE6BEFF,
  'new': 0xFFFF00,
  'olive': 0x808000,
  'orange': 0xFFA500,
  'pink': 0xFFE1E6,
  'purple': 0x800080,
  'red': 0xFF0000,
  'silver': 0xC0C0C0,
  'white': 0xFFFFFF,
  'yellow': 0xFFFF00
};

List<String> parseListStringCalculated(String value) {
  if (value.isEmpty) return [];
  List<String> _retainer = [];
  value.split(regex).forEach((element) {
    _retainer.add(element.substring(element.indexOf('.') + 1));
  });
  return _retainer;
}

String parseCalculate(String operation) {
  try {
    Expression exp = Parser().parse(operation);
    return exp.evaluate(EvaluationType.REAL, null).toString();
  } catch (ex) {
    return "";
  }
}

List<String> parseListStringOperator(String value) {
  if (value.isEmpty) return [];
  List<String> _retainer = [];
  Iterable<Match> matches = regex.allMatches(value);
  matches.forEach((element) {
    _retainer.add(element.group(0));
  });
  return _retainer;
}

Color parseHexColor(String theme) {
  Color color;
  switch (theme) {
    case "Primary":
      color = Color.fromRGBO(0, 123, 255, 1.0);
      break;
    case "Secondary":
      color = Color.fromRGBO(108, 117, 125, 1.0);
      break;
    case "Info":
      color = Color.fromRGBO(23, 162, 184, 1.0);
      break;
    case "Success":
      color = Color.fromRGBO(40, 167, 69, 1.0);
      break;
    case "Danger":
      color = Color.fromRGBO(220, 53, 69, 1.0);
      break;
    case "Warning":
      color = Color.fromRGBO(255, 193, 7, 1.0);
      break;
    default:
      color = Color.fromRGBO(0, 123, 255, 1.0);
      break;
  }
  return color;
}

TextInputType parsetInputType(String type) {
  TextInputType _inputType;
  switch (type) {
    case "email":
      _inputType = TextInputType.emailAddress;
      break;
    case "number":
      _inputType = TextInputType.number;
      break;
    case "phoneNumber":
      _inputType = TextInputType.phone;
      break;
    case "url":
      _inputType = TextInputType.url;
      break;
    case "time":
      _inputType = TextInputType.datetime;
      break;
    case "datetime":
      _inputType = TextInputType.datetime;
      break;
    case "calendar":
      _inputType = TextInputType.datetime;
      break;
    case "textarea":
      _inputType = TextInputType.multiline;
      break;
    default:
      _inputType = TextInputType.text;
      break;
  }
  return _inputType;
}

Future<bool> checkSignatures(List<Widget> widgets) async {
  dynamic converted;
  widgets.asMap().forEach(
    (key, value) async {
      switch (value.runtimeType) {
        case SignatureCreator:
          result = (value as SignatureCreator).controller.isEmpty;
          break;
        case PagerParserWidget:
          converted = value as PagerParserWidget;
          parseWidgets(converted.widgets);
          break;
        case ColumnParserWidget:
          converted = value as ColumnParserWidget;
          parseWidgets(converted.widgets);
          break;
      }
    },
  );
  return result;
}

//Parse a list widgets to a map with the result.
Future<Map<String, dynamic>> parseWidgets(List<Widget> widgets) async {
  dynamic converted;
  widgets.asMap().forEach(
    (key, value) async {
      switch (value.runtimeType) {
        case FileCreator:
          converted = value as FileCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case TextFieldCreator:
          converted = value as TextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case TextAreaCreator:
          converted = value as TextAreaCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case UrlTextFieldCreator:
          converted = value as UrlTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case PhoneTextFieldCreator:
          converted = value as PhoneTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case NumberTextFieldCreator:
          converted = value as NumberTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case EmailTextFieldCreator:
          converted = value as EmailTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case DateTextFieldCreator:
          converted = value as DateTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case CheckboxCreator:
          converted = value as CheckboxCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case TimeTextFieldCreator:
          converted = value as TimeTextFieldCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case SignatureCreator:
          converted = value as SignatureCreator;
          map[converted.keyValue()] = converted.data;
          break;
        case SelectParserWidget:
          converted = value as SelectParserWidget;
          map[converted.keyValue()] = converted.data;
          break;
        case PagerParserWidget:
          converted = value as PagerParserWidget;
          parseWidgets(converted.widgets);
          break;
        case ColumnParserWidget:
          converted = value as ColumnParserWidget;
          parseWidgets(converted.widgets);
          break;
      }
    },
  );
  return map;
}

String convertFileToBase64(String filename) {
  return (filename == null || filename.isEmpty)
      ? ""
      : (base64Encode(File(filename).readAsBytesSync()));
}

Future<String> convertSignatureToBase64(SignatureController controller) async {
  return (await controller.toPngBytes() != null)
      ? base64Encode(await controller.toPngBytes())
      : "";
}

//Parse Color from String name
Color parseColor(String color) {
  var v = colorMap[color];
  Color out = Color((0xff << 24) | v);
  return (v == null) ? Colors.cyan : out;
}

Color parseRgb(String input) {
  var startIndex = input.indexOf("(") + 1;
  var endIndex = input.indexOf(")");
  var values =
      input.substring(startIndex, endIndex).split(",").map((v) => int.parse(v));
  return Color.fromARGB(
      255, values.elementAt(0), values.elementAt(1), values.elementAt(2));
}
