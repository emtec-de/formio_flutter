import 'package:formio_flutter/src/abstraction/abstraction.dart';

class NonResponseWidgetClickListener implements ClickListener {
  @override
  void onClicked(String event) {
    print("receiver click event: " + event);
  }
}
