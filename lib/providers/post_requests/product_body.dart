import 'package:flutter/foundation.dart';

class ProductBody extends ChangeNotifier {
  Map<String, dynamic> _productBody = {
    "name": "",
    "description": "",
    "shop_id": "",
    "base_price": 0.0,
    "quantity": 0,
    "gallery": [],
    "product_category": "A",
    "status": "enabled,"
  };
  Map get data => _productBody;

  String get name => data['name'];
  String get description => data['description'];
  String get shopId => data['shop_id'];
  double get basePrice => data['base_price'];
  int get quantity => data['quantity'];
  String get productCategory => data['product_category'];
  String get status => data['status'];
  List<Map<String, dynamic>> get gallery => data['gallery'];

  void update({
    String name,
    String description,
    String shopId,
    double basePrice,
    int quantity,
    String productCategory,
    String status,
    List<Map<String, dynamic>> gallery,
  }) {
    _productBody['name'] = name ?? _productBody['name'];
    _productBody['description'] = description ?? _productBody['description'];
    _productBody['shop_id'] = shopId ?? _productBody['shop_id'];
    _productBody['base_price'] = basePrice ?? _productBody['base_price'];
    _productBody['quantity'] = quantity ?? _productBody['quantity'];
    _productBody['product_category'] =
        productCategory ?? _productBody['product_category'];
    _productBody['status'] = status ?? _productBody['status'];
    _productBody['gallery'] = gallery ?? _productBody['gallery'];

    notifyListeners();
  }

  void clear() => update(
        name: "",
        description: "",
        shopId: "",
        basePrice: 0.0,
        quantity: 0,
        productCategory: "A",
        status: "enabled",
        gallery: [],
      );
}
