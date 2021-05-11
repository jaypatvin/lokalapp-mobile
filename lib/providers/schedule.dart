import 'package:flutter/material.dart';

class Schedule extends ChangeNotifier {
  String dropDownValue;
  List<int> markedDaysMap = [];

  String _repeatController = '';

  String get getDropDownVal => dropDownValue;
  List<int> get getMarketDaysMap => markedDaysMap;
  String get getRepeatController => _repeatController;

  void setDisplayText(String text) {
    _repeatController = text;
    notifyListeners();
  }

  void setDropDownValues(String newVal) {
    dropDownValue = newVal;
    notifyListeners();
  }
}
