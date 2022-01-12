import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:formio_flutter/formio_flutter.dart';

/// Extends the abstract class [WidgetParser]
class ButtonParser extends WidgetParser {
  /// Returns a [Widget] of type [Button]

  Color parseRgb(String input) {
    var startIndex = input.indexOf("(") + 1;
    var endIndex = input.indexOf(")");
    var values = input
        .substring(startIndex, endIndex)
        .split(",")
        .map((v) => int.parse(v));
    return Color.fromARGB(
        255, values.elementAt(0), values.elementAt(1), values.elementAt(2));
  }

  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider? widgetProvider) {
    String clickEvent = map.action ?? "";
    bool? isVisible = true;
    bool? isDisabled = false;

    /// Declared [WidgetProvider] to consume the [Map<String, dynamic>] created from it.
    var button = map.hidden!
        ? SizedBox.shrink()
        : StreamBuilder(
            stream: widgetProvider!.widgetBloc.widgetsStream,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              isVisible = (map.conditional != null && snapshot.data != null)
                  ? (snapshot.data!.containsKey(map.conditional!.when) &&
                          snapshot.data![map.conditional!.when].toString() ==
                              map.conditional!.eq)
                      ? map.conditional!.show
                      : !map.conditional!.show!
                  : true;
              isDisabled = (map.disableConditional != null &&
                      snapshot.data != null)
                  ? (snapshot.data!.containsKey(map.disableConditional!.when) &&
                          snapshot.data![map.disableConditional!.when]
                                  .toString() ==
                              map.disableConditional!.eq)
                      ? map.disableConditional!.disable
                      : !map.disableConditional!.disable!
                  : false;
              return (!isVisible!)
                  ? SizedBox.shrink()
                  : Padding(
                      padding: map.marginData != null
                          ? EdgeInsets.only(
                              top: map.marginData!.top!,
                              left: map.marginData!.left!,
                              right: map.marginData!.right!,
                              bottom: map.marginData!.bottom!,
                            )
                          : EdgeInsets.zero,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: map.borderData != null &&
                                      map.borderData!.borderRadius != null
                                  ? BorderRadius.circular(
                                      map.borderData!.borderRadius!,
                                    )
                                  : BorderRadius.zero,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            isDisabled!
                                ? parseHexColor(map.theme ?? "primary")
                                    .withOpacity(0.5)
                                : parseHexColor(map.theme ?? "primary"),
                          ),
                        ),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              map.leftIcon != null
                                  ? LeftIconWidgetParser()
                                      .parse(map, context, null, null)
                                  : SizedBox.shrink(),
                              Padding(
                                padding: map.paddingData != null
                                    ? EdgeInsets.only(
                                        top: map.paddingData!.top!,
                                        left: map.paddingData!.left!,
                                        right: map.paddingData!.right!,
                                        bottom: map.paddingData!.bottom!,
                                      )
                                    : EdgeInsets.zero,
                                child: Text(
                                  map.label!,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: (map.textStyleData != null)
                                        ? map.textStyleData!.fontSize
                                        : 16,
                                    color: (map.textStyleData != null)
                                        ? map.textStyleData!.color != null
                                            ? parseRgb(
                                                map.textStyleData!.color!)
                                            : Colors.white
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              map.rightIcon != null
                                  ? RightIconWidgetParser()
                                      .parse(map, context, null, null)
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                        onPressed: isDisabled!
                            ? null
                            : () => listener.onClicked(clickEvent),
                      ),
                    );
              // Padding(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              //     child: NeumorphicButton(
              //       style: NeumorphicStyle(
              //         color: parseHexColor(map.theme ?? "primary"),
              //         shadowLightColor:
              //             parseHexColor(map.theme ?? "primary"),
              //       ),
              //       child: (map.leftIcon != null || map.rightIcon != null)
              //           ? SizedBox(
              //               width: MediaQuery.of(context).size.width * 0.5,
              //               child: Row(
              //                 mainAxisAlignment:
              //                     MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   LeftIconWidgetParser().parse(
              //                       map, context, listener, widgetProvider),
              //                   Text(
              //                     map.label,
              //                     softWrap: true,
              //                     style: TextStyle(
              //                       fontSize: 20.0,
              //                       color: Colors.white,
              //                     ),
              //                   ),
              //                   RightIconWidgetParser().parse(
              //                       map, context, listener, widgetProvider),
              //                 ],
              //               ),
              //             )
              //           : Text(
              //               map.label,
              //               softWrap: true,
              //               style: TextStyle(
              //                 fontSize: 20.0,
              //                 color: Colors.white,
              //               ),
              //             ),
              //       onPressed: (map.disabled)
              //           ? null
              //           : () => listener.onClicked(clickEvent),
              //     ),
              //   );
            },
          );
    return button;
  }

  /// [widgetName] => "button"
  @override
  String get widgetName => "button";
}
