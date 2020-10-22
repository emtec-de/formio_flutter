import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

class SignatureParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    return SignatureCreator(
      map: map,
    );
  }

  @override
  String get widgetName => "signature";
}

// ignore: must_be_immutable
class SignatureCreator extends StatefulWidget implements Manager {
  SignatureController controller = new SignatureController();

  final Component map;
  WidgetProvider widgetProvider;

  SignatureCreator({
    this.map,
  });
  @override
  _SignatureCreatorState createState() => _SignatureCreatorState();

  @override
  String keyValue() => map.key ?? "signatureField";

  @override
  get data async => await convertSignatureToBase64(controller);
}

class _SignatureCreatorState extends State<SignatureCreator> {
  String characters = "";

  @override
  void initState() {
    super.initState();
    widget.controller = SignatureController(
      penStrokeWidth: 5,
      penColor: parseColor(widget.map.penColor),
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void didChangeDependencies() {
    widget.widgetProvider = Provider.of<WidgetProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isVisible = true;
    return Container(
      child: StreamBuilder(
          stream: widget.widgetProvider.widgetsStream,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            isVisible = (widget.map.conditional != null &&
                    snapshot.data != null)
                ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                        snapshot.data[widget.map.conditional.when].toString() ==
                            widget.map.conditional.eq)
                    ? widget.map.conditional.show
                    : true
                : true;
            if (!isVisible) widget.controller.clear();
            return (!isVisible)
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.map.label,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17.0),
                      ),
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Colors.black),
                            ),
                            child: Signature(
                              controller: widget.controller,
                              width: size.width,
                              height: size.height * 0.2,
                              backgroundColor:
                                  parseRgb(widget.map.backgroundColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () => widget.controller.clear(),
                              child: CircleAvatar(
                                child: Icon(Icons.refresh),
                                radius: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      (widget.map.footer == null)
                          ? Container()
                          : Text(
                              widget.map.footer,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0,
                              ),
                            ),
                    ],
                  );
          }),
    );
  }
}
