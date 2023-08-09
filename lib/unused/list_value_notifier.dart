import 'package:flutter/material.dart';

// Doing this only to avoid dart warning when you use notify listener with valuenotifier
class ListValueNotifier<T> extends ValueNotifier<T> {
  ListValueNotifier(super.value);

  @override
  void notifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      super.notifyListeners();
    });
  }
}
