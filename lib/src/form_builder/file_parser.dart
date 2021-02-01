import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// Extends the abstract class [WidgetParser]
class FileParser extends WidgetParser {
  /// Returns a [Widget] of type [File]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider widgetProvider) {
    return FileCreator(
      map: map,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "file"
  @override
  String get widgetName => "file";
}

// ignore: must_be_immutable
class FileCreator extends StatefulWidget implements Manager {
  final Component map;
  final WidgetProvider widgetProvider;
  PlatformFile _platformFile;
  FileCreator({this.map, this.widgetProvider});
  @override
  _FileCreatorState createState() => _FileCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map.key ?? "fileField";

  /// Retrieve the file.
  get platform => _platformFile;

  /// Current value of the [Widget]
  @override
  get data => convertFileToBase64("${_platformFile.path}") ?? "";
}

class _FileCreatorState extends State<FileCreator> {
  List<PlatformFile> _paths;
  String _extension;

  @override
  void dispose() {
    super.dispose();
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
        allowCompression: true,
        allowMultiple: false,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    if (_paths != null && _paths.isNotEmpty) {
      _paths.forEach((path) {
        widget._platformFile = path;
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = true;
    return StreamBuilder(
      stream: widget.widgetProvider.widgetBloc.widgetsStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        isVisible = (widget.map.conditional != null && snapshot.data != null)
            ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                    snapshot.data[widget.map.conditional.when].toString() ==
                        widget.map.conditional.eq)
                ? widget.map.conditional.show
                : !widget.map.conditional.show
            : true;
        return (!isVisible)
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        child: ListTile(
                          leading: NeumorphicButton(
                            onPressed: () => _openFileExplorer(),
                            child: Flex(
                              mainAxisSize: MainAxisSize.min,
                              direction: Axis.horizontal,
                              children: [
                                Text("Upload"),
                                Icon(Icons.file_upload),
                              ],
                            ),
                          ),
                          isThreeLine: true,
                          title: widget._platformFile != null &&
                                  widget._platformFile.name.isNotEmpty
                              ? Align(
                                  alignment: Alignment(-1.0, 0),
                                  child: NeumorphicText(
                                    widget._platformFile.name.length > 25
                                        ? "${widget._platformFile.name.substring(1, 25)}..."
                                        : widget._platformFile.name,
                                    style: NeumorphicStyle(color: Colors.black),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : Container(),
                          subtitle: widget._platformFile != null &&
                                  widget._platformFile.name.isNotEmpty
                              ? Align(
                                  alignment: Alignment(-1.0, 0),
                                  child: NeumorphicText(
                                    "extension: ${widget._platformFile.extension}",
                                    style: NeumorphicStyle(color: Colors.black),
                                    textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
