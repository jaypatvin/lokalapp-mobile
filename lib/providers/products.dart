import 'dart:collection';
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
  // List<Product> get items {
  //   return [..._products];
  // }
  // UnmodifiableListView<Product> get items => UnmodifiableListView(_products);

  UnmodifiableListView<Product> get items {
    return UnmodifiableListView(
      _products.where((product) => !product.archived),
    );
  }

  String get communityId => _communityId;

  void setCommunityId(String id) {
    _communityId = id;
  }

  void setIdToken(String id) {
    _idToken = id;
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  List<Product> findByUser(String userId) {
    return items.where((product) => product.userId == userId).toList();
  }

  List<Product> findByShop(String shopId) {
    return items.where((product) => product.shopId == shopId).toList();
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
        print(_product.archived);
        products.add(_product);
      }
      _products = products;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> create(Map data) async {
    try {
      var response = await LokalApiService.instance.product
          .create(data: data, idToken: _idToken);

      if (response.statusCode != 200) return null;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        // await fetch(authToken);
        final product = Product.fromMap(body['data']);
        _products.add(product);
        notifyListeners();
        return product.id;
      }
      return null;
    } catch (e) {
      return null;
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
        fetchProductById(id: id);
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
      final response = await LokalApiService.instance.product.setAvailability(
        productId: id,
        data: data,
        idToken: _idToken,
      );
      if (response.statusCode != 200) return false;

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        // await fetch(authToken);
        // manually fetch data
        fetchProductById(id: id);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteProduct({@required String id}) async {
    final response = await LokalApiService.instance.product
        .deleteProduct(id: id, idToken: _idToken);

    if (response.statusCode != 200) throw (response.reasonPhrase);

    Map body = json.decode(response.body);

    if (body['status'] == 'ok') {
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } else {
      throw (body['status']);
    }
  }

  Future<void> fetchProductById({@required String id}) async {
    try {
      final response = await LokalApiService.instance.product.getById(
        productId: id,
        idToken: _idToken,
      );
      if (response.statusCode != 200) throw (response.reasonPhrase);

      Map body = json.decode(response.body);

      if (body['status'] == 'ok') {
        final product = Product.fromMap(body['data']);
        final index = _products.indexWhere((product) => product.id == id);
        if (index < 0) {
          _products.add(product);
          notifyListeners();
        } else {
          _products[index] = product;
          notifyListeners();
        }
      }
      throw (response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
