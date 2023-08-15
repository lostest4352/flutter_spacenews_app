import 'package:flutter/material.dart';

class BoolNotifier extends ChangeNotifier {
  List<bool> tileClicked = [];

  void changeListTileState(int index) {
    tileClicked[index] = !tileClicked[index];
    notifyListeners();
  }
}
