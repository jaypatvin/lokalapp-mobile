import 'dart:collection';

import 'package:flutter/foundation.dart';

class ShoppingCart extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map> get items => UnmodifiableListView(_products);

  bool contains(String productId) {
    var index = _products.indexWhere((item) => item['product'] == productId);
    return index > -1;
  }

  void add({@required String productId, @required int quantity, String notes}) {
    _products.add({'product': productId, 'quantity': quantity, 'notes': notes});
    notifyListeners();
  }

  void remove(String productId) {
    _products.removeWhere((item) => item['product'] == productId);
    notifyListeners();
  }

  void clear() {
    _products = [];
    notifyListeners();
  }
}
