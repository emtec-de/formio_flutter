import 'dart:convert';

FormCollection formCollectionFromJson(String str) =>
    FormCollection.fromJson(json.decode(str));

String formCollectionToJson(FormCollection data) => json.encode(data.toJson());

class FormCollection {
  FormCollection({
    this.display,
    this.components,
  });

  String display;
  List<Component> components;

  factory FormCollection.fromJson(Map<String, dynamic> json) => FormCollection(
        display: json["display"],
        components: List<Component>.from(
            json["components"].map((x) => Component.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "display": display,
        "components": List<dynamic>.from(components.map((x) => x.toJson())),
      };
}

class Component {
  Component({
    this.label,
    this.labelPosition,
    this.columns,
    this.showWordCount,
    this.defaultValue,
    this.backgroundColor,
    this.storage,
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

  String label;
  bool showWordCount;
  String labelPosition;
  List<Component> component;
  List<Component> columns;
  int width;
  int offset;
  int push;
  int pull;
  String calculateValue;
  String storage;
  String fileNameTemplate;
  bool webcam;
  String penColor;
  String backgroundColor;
  String footer;
  bool mask;
  String prefix;
  dynamic defaultValue;
  Data data;
  String suffix;
  String inputMask;
  bool tableView;
  bool hidden;
  bool disabled;
  String key;
  Conditional conditional;
  String type;
  bool input;
  bool disableOnInvalid;
  String action;
  bool showValidations;
  String theme;
  String size;
  bool block;
  String leftIcon;
  String rightIcon;
  String shortcut;
  String description;
  String tooltip;
  String tabindex;
  bool modalEdit;
  List<String> tags;

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

  Map<String, dynamic> toJson() => {
        "components": (component == null)
            ? null
            : List<dynamic>.from(component.map((x) => x)),
        "columns": (columns == null)
            ? null
            : List<dynamic>.from(component.map((x) => x)),
        "storage": (storage == null) ? "base64" : storage,
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

class Conditional {
  bool show;
  String when;
  String eq;

  Conditional({this.show, this.when, this.eq});

  factory Conditional.fromJson(Map<String, dynamic> json) => Conditional(
        show: (json["show"] == null) ? true : json["show"],
        when: (json["when"] == null) ? "" : json["when"],
        eq: (json["eq"] == null) ? "" : json["eq"],
      );

  Map<String, dynamic> toJson() => {
        "show": show == null ? true : show,
        "when": when == null ? "" : when,
        "eq": eq == null ? "" : eq
      };
}

class Data {
  Data({
    this.values,
  });
  List<Value> values;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.label,
    this.value,
  });

  String label;
  String value;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}
