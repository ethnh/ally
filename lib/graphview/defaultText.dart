import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/scheduler.dart';

TextStyle calculateTextColor() {
  var defaultText = TextStyle(
    // This is the default color for the text on graph lines
    fontSize: 14,
    color: SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark
        ? Colors.white
        : Colors.black,
    fontWeight: FontWeight.w600,
  );
  return defaultText;
}
