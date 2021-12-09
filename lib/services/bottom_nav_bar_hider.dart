import 'package:flutter/foundation.dart';

class BottomNavBarHider extends ChangeNotifier {
  bool _hidden = false;
  bool get isHidden => _hidden;
  set isHidden(bool value) {
    if (_hidden == value) return;
    _hidden = value;
    notifyListeners();
  }
}
