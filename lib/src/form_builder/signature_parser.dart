import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class SignatureParser extends WidgetParser {
  /// Returns a [Widget] of type [Signature]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider? widgetProvider) {
    return SignatureCreator(
      map: map,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "signature"
  @override
  String get widgetName => "signature";
}

// ignore: must_be_immutable
class SignatureCreator extends StatefulWidget implements Manager {
  SignatureController controller = new SignatureController();

  final Component? map;
  final WidgetProvider? widgetProvider;

  SignatureCreator({
    this.map,
    this.widgetProvider,
  });
  @override
  _SignatureCreatorState createState() => _SignatureCreatorState();

  /// Returns a [String] with the value contained inside [Component.key]
  @override
  String? keyValue() => map!.key;

  /// Current value of the [Widget]
  @override
  get data async => await convertSignatureToBase64(controller);
}

class _SignatureCreatorState extends State<SignatureCreator> {
  String characters = "";
  bool isNewSignature = true;
  final Map<String?, dynamic> _mapper = new Map();

  @override
  void initState() {
    super.initState();
    _mapper[widget.map!.key] = {""};
    isNewSignature = (widget.map!.defaultValue != null) ? false : true;
    widget.controller = SignatureController(
      penStrokeWidth: 5,
      penColor: parseColor(widget.map!.penColor),
      exportBackgroundColor: Colors.white,
    );
    Future.delayed(Duration(milliseconds: 10), () {
      _mapper.update(widget.map!.key, (value) => '');
      widget.widgetProvider!.widgetBloc.registerMap(_mapper);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool? isVisible = true;
    return Container(
      child: StreamBuilder(
          stream: widget.widgetProvider!.widgetBloc.widgetsStream,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            isVisible = (widget.map!.conditional != null &&
                    snapshot.data != null)
                ? (snapshot.data!.containsKey(widget.map!.conditional!.when) &&
                        snapshot.data![widget.map!.conditional!.when]
                                .toString() ==
                            widget.map!.conditional!.eq)
                    ? widget.map!.conditional!.show
                    : !widget.map!.conditional!.show!
                : true;
            if (!isVisible!) widget.controller.clear();
            return (!isVisible!)
                ? SizedBox.shrink()
                : Neumorphic(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        NeumorphicText(
                          widget.map!.label!,
                          textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17.0),
                          style: NeumorphicStyle(
                              depth: 13.0,
                              intensity: 0.90,
                              color: Colors.black),
                        ),
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Neumorphic(
                              style: NeumorphicStyle(
                                border: NeumorphicBorder(
                                    width: 0.4, color: Colors.grey),
                              ),
                              child: (widget.map!.defaultValue != null &&
                                      !isNewSignature)
                                  ? Column(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          width: size.width,
                                          child: NeumorphicText(
                                            'Signature Recorded',
                                            style: NeumorphicStyle(
                                                depth: 13.0,
                                                intensity: 0.90,
                                                color: Colors.black),
                                            textStyle: NeumorphicTextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          width: size.width,
                                          child: Center(
                                            child: decodeSignatureFromBase64(
                                              signature:
                                                  widget.map!.defaultValue,
                                              color: parseRgb(
                                                widget.map!.backgroundColor!,
                                              ),
                                              width: size.width,
                                              height: size.height * 0.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Signature(
                                      controller: widget.controller,
                                      width: size.width,
                                      height: size.height * 0.2,
                                      backgroundColor: parseRgb(
                                          widget.map!.backgroundColor!),
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => isNewSignature = true);
                                  widget.controller.clear();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.refresh),
                                  radius: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        (widget.map!.footer == null)
                            ? Container()
                            : Text(
                                widget.map!.footer!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.0,
                                ),
                              ),
                      ],
                    ),
                  );
          }),
    );
  }
}
