import 'package:formio_flutter/src/abstraction/abstraction.dart';

/// [NonResponseWidgetClickListener] is used in case of a [widget] doesn't need a click event.
class NonResponseWidgetClickListener implements ClickListener {
  @override
  void onClicked(String event) {
    print("receiver click event: " + event);
  }
}
