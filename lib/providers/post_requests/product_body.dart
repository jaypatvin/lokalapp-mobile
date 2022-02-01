import 'package:flutter/foundation.dart';

class ProductBody extends ChangeNotifier {
  final Map<String, dynamic> _productBody = {
    'name': '',
    'description': '',
    'shop_id': '',
    'base_price': 0.0,
    'quantity': 0,
    'gallery': <Map<String, dynamic>>[],
    'product_category': '',
    'status': 'enabled',
    'can_subscribe': true,
    'availability': <String, dynamic>{},
  };
  Map<String, dynamic> get data => _productBody;

  String? get name => data['name'];
  String? get description => data['description'];
  String? get shopId => data['shop_id'];
  double? get basePrice => data['base_price'];
  int? get quantity => data['quantity'];
  String? get productCategory => data['product_category'];
  String? get status => data['status'];
  bool get canSubscribe => data['can_subscribe'];
  List<Map<String, dynamic>>? get gallery => data['gallery'];
  Map<String, dynamic>? get availability => data['availability'];

  void update({
    String? name,
    String? description,
    String? shopId,
    double? basePrice,
    int? quantity,
    String? productCategory,
    String? status,
    bool? canSubscribe,
    List<Map<String, dynamic>>? gallery,
    Map<String, dynamic>? availability,
    bool notify = true,
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
    _productBody['can_subscribe'] =
        canSubscribe ?? _productBody['can_subscribe'];
    _productBody['availability'] = availability ?? _productBody['availability'];

    if (notify) notifyListeners();
  }

  void clear() => update(
        name: '',
        description: '',
        shopId: '',
        basePrice: 0.0,
        quantity: 0,
        productCategory: 'A',
        status: 'enabled',
        gallery: [],
      );
}
