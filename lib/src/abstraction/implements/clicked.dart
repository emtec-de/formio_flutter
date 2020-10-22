import 'package:formio_flutter/src/abstraction/abstraction.dart';

class DefaultClickListener implements ClickListener {
  @override
  void onClicked(String event) {
    print("Click event: $event");
  }
}
