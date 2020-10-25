import 'dart:convert';

/// Returns a [FormCollection] from a [String] that possees a json.
FormCollection formCollectionFromJson(String str) =>
    FormCollection.fromJson(json.decode(str));

/// Returns a json representation of the [FormCollection] class.
String formCollectionToJson(FormCollection data) => json.encode(data.toJson());

/// [FormCollection] is used to be linked with the data obtained from FormIO.js
class FormCollection {
  FormCollection({
    this.display,
    this.components,
  });

  /// contains the type of form that is gonna be used.
  ///
  /// ex: "form", "pager", "etc".
  String display;

  /// contains a list of [Component].
  ///
  /// this is used to create their respective [widgets] and [actions]
  List<Component> components;

  /// Returns a [FormCollection] from a [Map<String, dynamic>].
  factory FormCollection.fromJson(Map<String, dynamic> json) => FormCollection(
        display: json["display"],
        components: List<Component>.from(
            json["components"].map((x) => Component.fromJson(x))),
      );

  /// Returns a [Map<String, dynamic>] representation of the [FormCollection] class.
  Map<String, dynamic> toJson() => {
        "display": display,
        "components": List<dynamic>.from(components.map((x) => x.toJson())),
      };
}

/// [Component] is used to declare all the actions used to build the widgets for
/// each time this class is called.
class Component {
  Component({
    this.label,
    this.labelPosition,
    this.columns,
    this.showWordCount,
    this.defaultValue,
    this.backgroundColor,
    this.storage,
    this.currency,
    this.fileNameTemplate,
    this.webcam,
    this.data,
    this.footer,
    this.mask,
    this.prefix,
    this.suffix,
    this.penColor,
    this.inputMask,
    this.tableView,
    this.key,
    this.conditional,
    this.type,
    this.input,
    this.disableOnInvalid,
    this.calculateValue,
    this.hidden,
    this.disabled,
    this.action,
    this.showValidations,
    this.theme,
    this.size,
    this.block,
    this.leftIcon,
    this.rightIcon,
    this.shortcut,
    this.description,
    this.tooltip,
    this.tabindex,
    this.modalEdit,
    this.component,
    this.tags,
    this.width,
    this.offset,
    this.push,
    this.pull,
  });

  /// label or title.
  String label;

  /// set the counter for a [textfield]
  bool showWordCount;

  /// set the [position] of a [label] in a [textfield]
  String labelPosition;

  /// self-reference of [Component].
  List<Component> component;

  /// similar to [components], but is based on a column key.
  List<Component> columns;

  /// set the [width] of the widget.
  int width;

  /// set the [offset] of the widget.
  int offset;

  /// set a [int]
  int push;

  /// set a [int]
  int pull;

  /// set a [String] with a calculated value.
  /// ```dart
  /// calculateValue => "calculateValue=data.valueA*data.valueB"
  /// ```
  String calculateValue;

  /// set a [String]
  String storage;

  /// set a custom template for a [file] name.
  String fileNameTemplate;

  /// set a [bool] for webcam.
  bool webcam;

  /// set a [String] to declare the pen color used in the [Signature] widget.
  String penColor;

  /// set a [String] to declare the pen background used in the [Signature] widget.
  String backgroundColor;

  /// set a [String] in case of a footer.
  String footer;

  /// set a [bool] to declare if the widget is gonna be masked.
  bool mask;

  /// set a [String] to add a [prefix] into a [textfield]
  String prefix;

  /// set a [dynamic] value to be attached to any [widget]
  dynamic defaultValue;

  /// set a [Data] value.
  Data data;

  /// set a [String] to add a [suffix] into a [textfield]
  String suffix;

  /// set a [String] to create a [Regex] with a custom [mask]
  String inputMask;

  /// set a [bool]
  bool tableView;

  /// set a [bool] if the component is gonna be displayed.
  bool hidden;

  /// set a [bool] if the component is gonna be disabled.
  bool disabled;

  /// set a [String] that contains the [key].
  ///
  /// This acts as an ID, it's need to be [unique].
  String key;

  /// set a [Conditional] type.
  Conditional conditional;

  /// Set a [String] for a money code.
  String currency;

  /// set a [String] value.
  String type;

  /// set a [bool] value.
  bool input;

  /// set a [bool] value.
  bool disableOnInvalid;

  /// set a [String] value.
  String action;

  /// set a [bool] value.
  bool showValidations;
  String theme;
  String size;

  /// set a [bool] value.
  bool block;

  /// set a [String] value.
  String leftIcon;

  /// set a [String] value.
  String rightIcon;

  /// set a [String] value.
  String shortcut;

  /// set a [String] value.
  String description;

  /// set a [String] value.
  String tooltip;

  /// set a [String] value.
  String tabindex;

  /// set a [bool] value.
  bool modalEdit;

  /// set a [List<String>]
  List<String> tags;

  /// Returns a [Component] from a [String] that possees a json.
  factory Component.fromJson(Map<String, dynamic> json) => Component(
        component: (json["components"] == null)
            ? null
            : List<Component>.from(
                json["components"].map((x) => Component.fromJson(x))),
        columns: (json["columns"] == null)
            ? null
            : List<Component>.from(
                json["columns"].map((x) => Component.fromJson(x))),
        label: json["label"],
        currency: json["currency"] == null ? null : json["currency"],
        calculateValue:
            json["calculateValue"] == null ? null : json["calculateValue"],
        storage: (json["storage"] == null) ? "base64" : json["storage"],
        fileNameTemplate:
            (json["fileNameTemplate"] == null) ? "" : json["fileNameTemplate"],
        webcam: (json["webcam"] == null) ? false : json["webcam"],
        showWordCount:
            (json["showWordCount"] == null) ? null : json["showWordCount"],
        penColor: (json["penColor"] == null) ? "black" : json["penColor"],
        footer: (json["footer"] == null) ? null : json["footer"],
        backgroundColor: (json["backgroundColor"] == null)
            ? "rgb(255, 255, 255)"
            : json["backgroundColor"],
        mask: (json["mask"] == null) ? false : json["mask"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        defaultValue: json["defaultValue"] == null
            ? []
            : (json["defaulValue"] is List<String>)
                ? List<String>.from(json["defaultValue"].map((x) => x))
                : json["defaultValue"],
        labelPosition:
            json["labelPosition"] == null ? null : json["labelPosition"],
        prefix: json["prefix"] == null ? null : json["prefix"],
        suffix: json["suffix"] == null ? null : json["suffix"],
        inputMask: json["inputMask"] == null ? null : json["inputMask"],
        tableView: json["tableView"],
        key: json["key"],
        conditional: json["conditional"] == null
            ? null
            : Conditional.fromJson(json["conditional"]),
        type: json["type"],
        hidden: json["hidden"] == null ? false : json["hidden"],
        disabled: json["disabled"] == null ? false : json["disabled"],
        input: json["input"],
        disableOnInvalid:
            json["disableOnInvalid"] == null ? null : json["disableOnInvalid"],
        action: json["action"] == null ? null : json["action"],
        showValidations:
            json["showValidations"] == null ? null : json["showValidations"],
        theme: json["theme"] == null ? null : json["theme"],
        size: json["size"] == null ? null : json["size"],
        width: json["width"] == null ? 0 : json["width"],
        offset: json["offset"] == null ? 0 : json["offset"],
        push: json["push"] == null ? 0 : json["push"],
        pull: json["pull"] == null ? 0 : json["pull"],
        block: json["block"] == null ? null : json["block"],
        leftIcon: json["leftIcon"] == null ? null : json["leftIcon"],
        rightIcon: json["rightIcon"] == null ? null : json["rightIcon"],
        shortcut: json["shortcut"] == null ? null : json["shortcut"],
        description: json["description"] == null ? null : json["description"],
        tooltip: json["tooltip"] == null ? null : json["tooltip"],
        tabindex: json["tabindex"] == null ? null : json["tabindex"],
        modalEdit: json["modalEdit"] == null ? null : json["modalEdit"],
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
      );

  /// Returns a [Map<String, dynamic>] representation of the [Component] class.
  Map<String, dynamic> toJson() => {
        "components": (component == null)
            ? null
            : List<dynamic>.from(component.map((x) => x)),
        "columns": (columns == null)
            ? null
            : List<dynamic>.from(component.map((x) => x)),
        "storage": (storage == null) ? "base64" : storage,
        "currency": (currency == null) ? "" : currency,
        "fileNameTemplate": (fileNameTemplate == null) ? "" : fileNameTemplate,
        "webcam": (webcam == null) ? false : webcam,
        "label": label,
        "mask": (mask == null) ? false : mask,
        "penColor": (penColor == null) ? "black" : penColor,
        "footer": (footer == null) ? null : footer,
        "backgroundColor":
            (backgroundColor == null) ? "rgb(255, 255, 255)" : backgroundColor,
        "showWordCount": (showWordCount == null) ? false : showWordCount,
        "labelPosition": (labelPosition == null) ? null : labelPosition,
        "data": data == null ? null : data.toJson(),
        "defaultValue": defaultValue == null
            ? []
            : (defaultValue is List<String>)
                ? List<dynamic>.from(tags.map((x) => x))
                : defaultValue as String,
        "prefix": (prefix == null) ? null : prefix,
        "suffix": (suffix == null) ? null : suffix,
        "inputMask": (inputMask == null) ? null : inputMask,
        "tableView": tableView,
        "key": key,
        "conditional": (conditional == null) ? null : conditional,
        "hidden": (hidden == null) ? false : hidden,
        "disabled": (disabled == null) ? false : disabled,
        "type": type,
        "input": input,
        "calculateValue": calculateValue == null ? null : calculateValue,
        "disableOnInvalid": disableOnInvalid == null ? null : disableOnInvalid,
        "action": action == null ? null : action,
        "showValidations": showValidations == null ? null : showValidations,
        "theme": theme == null ? null : theme,
        "size": size == null ? null : size,
        "width": width == null ? 0 : width,
        "offset": offset == null ? 0 : offset,
        "push": push == null ? 0 : push,
        "pull": pull == null ? 0 : pull,
        "block": block == null ? null : block,
        "leftIcon": leftIcon == null ? null : leftIcon,
        "rightIcon": rightIcon == null ? null : rightIcon,
        "shortcut": shortcut == null ? null : shortcut,
        "description": description == null ? null : description,
        "tooltip": tooltip == null ? null : tooltip,
        "tabindex": tabindex == null ? null : tabindex,
        "modalEdit": modalEdit == null ? null : modalEdit,
        "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
      };
}

/// [Conditional] is required everytime a widget needs a realtime validation.
class Conditional {
  /// set a [bool] if the widget is gonna be displayed.
  bool show;

  /// set a [String] with the widget [type].
  String when;

  /// set a condition declared as a [String].
  String eq;

  /// [Conditional] constructor.
  Conditional({this.show, this.when, this.eq});

  /// Returns a [FormCollection] from a [String] that possees a json.
  factory Conditional.fromJson(Map<String, dynamic> json) => Conditional(
        show: (json["show"] == null) ? true : json["show"],
        when: (json["when"] == null) ? "" : json["when"],
        eq: (json["eq"] == null) ? "" : json["eq"],
      );

  /// Returns a [Map<String, dynamic>] representation of the [Conditional] class.
  Map<String, dynamic> toJson() => {
        "show": show == null ? true : show,
        "when": when == null ? "" : when,
        "eq": eq == null ? "" : eq
      };
}

/// [Data] contains a list of objects used in a [SelectorParser].
class Data {
  Data({
    this.values,
  });

  /// set a list of [Value]
  List<Value> values;

  /// Returns a [Data] from a [String] that possees a json.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  /// Returns a [Map<String, dynamic>] representation of the [Data] class.
  Map<String, dynamic> toJson() => {
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
      };
}

/// [Value] contains the [values] and [key] that are gonna be displayed in a [SelectorParser]
class Value {
  Value({
    this.label,
    this.value,
  });

  /// set a [String]
  String label;

  /// set a [String]
  String value;

  /// Returns a [Value] from a [String] that possees a json.
  factory Value.fromJson(Map<String, dynamic> json) => Value(
        label: json["label"],
        value: json["value"],
      );

  /// Returns a [Map<String, dynamic>] representation of the [Value] class.
  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}
