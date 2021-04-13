import 'dart:collection';

import 'package:flutter/foundation.dart';

class ShoppingCart extends ChangeNotifier {
  Map<String, Map> _products = Map();
  Map<String, Map> get items => UnmodifiableMapView(_products);

  bool contains(String productId) {
    return _products.containsKey(productId);
  }

  void add({@required String productId, @required int quantity, String notes}) {
    _products[productId] = {'quantity': quantity, 'notes': notes};
    notifyListeners();
  }

  void remove(String productId) {
    _products.remove(productId);
    notifyListeners();
  }

  void clear() {
    _products.clear();
    notifyListeners();
  }
}
