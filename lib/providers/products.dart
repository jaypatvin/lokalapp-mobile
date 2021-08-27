import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/lokal_api_service.dart';

class Products extends ChangeNotifier {
  String _communityId;
  String _idToken;

  List<Product> _products = [];
  bool _isLoading;

  bool get isLoading => _isLoading;
  List<Product> get items {
    return [..._products];
  }

  String get communityId => _communityId;

  void setCommunityId(String id) {
    _communityId = id;
  }

  void setIdToken(String id) {
    _idToken = id;
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  List<Product> findByUser(String userId) {
    return _products.where((product) => product.userId == userId).toList();
  }

  List<Product> findByShop(String shopId) {
    return _products.where((product) => product.shopId == shopId).toList();
  }

  Future<void> fetch() async {
    _isLoading = true;
    var response = await LokalApiService.instance.product
        .getCommunityProducts(communityId: communityId, idToken: _idToken);

    if (response.statusCode != 200) {
      _isLoading = false;
      return;
    }

    Map data = json.decode(response.body);

    if (data['status'] == "ok") {
      List<Product> products = [];
      for (var product in data['data']) {
        var _product = Product.fromMap(product);
        products.add(_product);
      }
      _products = products;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(Map data) async {
    try {
      var response = await LokalApiService.instance.product
          .create(data: data, idToken: _idToken);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        // await fetch(authToken);
        _products.add(Product.fromMap(body['data']));
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update({
    @required String id,
    @required Map data,
  }) async {
    try {
      var response = await LokalApiService.instance.product
          .update(productId: id, data: data, idToken: _idToken);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        //await fetch(authToken);
        // the app should fetch manually
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setAvailability({
    @required String id,
    @required Map data,
  }) async {
    try {
      var response = await LokalApiService.instance.product
          .setAvailability(productId: id, data: data, idToken: _idToken);

      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        // await fetch(authToken);
        // manually fetch data
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
