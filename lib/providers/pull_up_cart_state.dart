import 'package:flutter/foundation.dart';

class PullUpCartState extends ChangeNotifier {
  bool _isPanelVisible = true;

  bool get isPanelVisible => _isPanelVisible;

  void setPanelVisibility(bool visible) {
    _isPanelVisible = visible;
    notifyListeners();
  }
}
