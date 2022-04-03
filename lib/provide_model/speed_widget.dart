import 'package:flutter/material.dart';

class SpeedWidget extends InheritedWidget {
  final int count;

  SpeedWidget({required this.count, required Widget child})
      : super(child: child);

  static SpeedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(covariant SpeedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    if (count == oldWidget.count) {
      return false;
    } else {
      return true;
    }
  }
}
