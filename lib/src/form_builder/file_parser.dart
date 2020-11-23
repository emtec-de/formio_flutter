import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// Extends the abstract class [WidgetParser]
class FileParser extends WidgetParser {
  /// Returns a [Widget] of type [File]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return FileCreator(
      map: map,
    );
  }

  /// [widgetName] => "file"
  @override
  String get widgetName => "file";
}

// ignore: must_be_immutable
class FileCreator extends StatefulWidget implements Manager {
  final Component map;
  String fileName = "";
  String absolutePath;
  WidgetProvider widgetProvider;
  FileCreator({this.map});
  @override
  _FileCreatorState createState() => _FileCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String keyValue() => map.key ?? "fileField";

  /// Current value of the [Widget]
  @override
  get data => convertFileToBase64(absolutePath) ?? "";
}

class _FileCreatorState extends State<FileCreator> {
  List<PlatformFile> _paths;
  String _extension;

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

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(
      () {
        widget.fileName = _paths != null
            ? _paths.map((e) => "${e.path}${e.name}").toString()
            : '...';
        widget.absolutePath = (_paths != null) ? _paths[0].path : "";
      },
    );
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
                : true
            : true;
        if (!isVisible) widget.fileName = "";
        return (!isVisible)
            ? Container()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () => _openFileExplorer(),
                          child: Text("Select a file"),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      final String name = 'File: ' + widget.fileName ?? '...';
                      return Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ListTile(
                          title: Text(
                            name,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
      },
    );
  }
}
