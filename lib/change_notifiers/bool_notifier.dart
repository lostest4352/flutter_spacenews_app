import 'package:flutter/material.dart';

class BoolNotifier with ChangeNotifier {
  List<bool> tileClicked = [];

  void changeListTileState(int index) {
    tileClicked[index] = !tileClicked[index];
    notifyListeners();
  }

  void changeAllTileState() {
    if (tileClicked.contains(false)) {
      tileClicked = List.filled(tileClicked.length, true);
    } else {
      tileClicked = List.filled(tileClicked.length, false);
    }
    notifyListeners();
  }
}
