import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

class ButtonParser extends WidgetParser {
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener) {
    String clickEvent = map.action ?? "";
    bool isVisible = true;
    WidgetProvider widgetProvider =
        Provider.of<WidgetProvider>(context, listen: false);
    var button = (map.hidden)
        ? Container()
        : StreamBuilder(
            stream: widgetProvider.widgetsStream,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              isVisible = (map.conditional != null && snapshot.data != null)
                  ? (snapshot.data.containsKey(map.conditional.when) &&
                          snapshot.data[map.conditional.when].toString() ==
                              map.conditional.eq)
                      ? map.conditional.show
                      : true
                  : true;
              return (!isVisible)
                  ? Container()
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            parseHexColor(map.theme)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      child: (map.leftIcon != null || map.rightIcon != null)
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  LeftIconWidgetParser()
                                      .parse(map, context, listener),
                                  Text(
                                    map.label,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  RightIconWidgetParser()
                                      .parse(map, context, listener),
                                ],
                              ),
                            )
                          : Text(
                              map.label,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                      onPressed: (map.disabled)
                          ? null
                          : () => listener.onClicked(clickEvent),
                    );
            });
    return button;
  }

  @override
  String get widgetName => "button";
}
