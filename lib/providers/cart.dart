import 'dart:collection';

import 'package:flutter/foundation.dart';

class CartOrder {
  int quantity;
  String notes;

  CartOrder({@required this.quantity, @required this.notes});
}

class ShoppingCart extends ChangeNotifier {
  Map<String, CartOrder> _products = Map();
  Map<String, CartOrder> get items => UnmodifiableMapView(_products);

  bool contains(String productId) {
    return _products.containsKey(productId);
  }

  void add({@required String productId, @required int quantity, String notes}) {
    _products[productId] = CartOrder(quantity: quantity, notes: notes);
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
