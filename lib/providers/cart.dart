import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:lokalapp/models/product.dart';

class ShoppingCart extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map> get items => UnmodifiableListView(_products);

  void add({@required String productId, @required int quantity, String notes}) {
    _products.add({'product': productId, 'quantity': quantity, 'notes': notes});
  }

  void remove(String productId) {
    _products.removeWhere((item) => item['product'] == productId);
  }
}
