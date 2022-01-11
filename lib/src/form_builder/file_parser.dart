import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/utils/mimes/mime_extension.dart' as mime;

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

  get mimeType => mime.contentType(_platformFile.extension);

  /// Current value of the [Widget]
  @override
  get data async {
    if (_platformFile == null) {
      return "";
    }
    var _conversion = await convertFileToBase64("${_platformFile.path}");
    return _conversion ?? "";
  }
}

class _FileCreatorState extends State<FileCreator> {
  List<PlatformFile> _paths;
  String _extension;
  final Map<String, dynamic> _mapper = new Map();

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
      await Future.forEach(_paths, (path) async {
        widget._platformFile = path;
        var base64 = await convertFileToBase64("${path.path}");
        _mapper.update(widget.map.key, (nVal) => base64 ?? "");
        widget.widgetProvider.widgetBloc.registerMap(_mapper);
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _mapper[widget.map.key] = {""};
    Future.delayed(Duration(milliseconds: 10), () {
      _mapper.update(widget.map.key, (value) => '');
      widget.widgetProvider.widgetBloc.registerMap(_mapper);
    });
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
            ? SizedBox.shrink()
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
