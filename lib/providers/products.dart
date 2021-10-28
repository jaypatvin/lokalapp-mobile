import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/api/api.dart';
import '../services/api/product_api_service.dart';
import '../services/database.dart';

class Products extends ChangeNotifier {
  Products._(this._apiService);

  factory Products(API api) {
    return Products._(ProductApiService(api));
  }

  final Database _db = Database.instance;
  final ProductApiService _apiService;

  List<Product> _products = [];

  String? _communityId;
  bool _isLoading = false;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _productsSubscription;

  UnmodifiableListView<Product> get items => UnmodifiableListView(
        _products.where((product) => !product.archived),
      );
  bool get isLoading => _isLoading;

  String? get communityId => _communityId;
  void setCommunityId(String? id) {
    if (id != null) {
      if (id == _communityId) return;
      _communityId = id;
      _productsSubscription?.cancel();
      _productsSubscription =
          _db.getCommunityProducts(id).listen(_productListener);
    }
  }

  void _productListener(QuerySnapshot<Map<String, dynamic>> query) async {
    final length = query.docChanges.length;
    if (_isLoading || length > 1) return;
    for (final change in query.docChanges) {
      final id = change.doc.id;
      final index = _products.indexWhere((p) => p.id == id);

      if (index >= 0) {
        _products[index] = await _apiService.getById(productId: id);
        notifyListeners();
        return;
      }

      final product = await _apiService.getById(productId: id);
      _products..add(product);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }

  Product? findById(String? id) {
    return items.firstWhereOrNull(
      (product) => product.id == id,
    );
  }

  List<Product> findByUser(String userId) {
    return items.where((product) => product.userId == userId).toList();
  }

  List<Product> findByShop(String shopId) {
    return items.where((product) => product.shopId == shopId).toList();
  }

  Future<void> fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _apiService.getCommunityProducts(
        communityId: _communityId!,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> create(Map<String, dynamic> body) async {
    try {
      final _product = await _apiService.create(body: body);
      _products.add(_product);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _apiService.update(productId: id, body: data);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> setAvailability({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _apiService.setAvailability(
        productId: id,
        body: data,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _apiService.deleteProduct(productId: productId);
    } catch (e) {
      throw e;
    }
  }

  Future<Product> fetchProductById(String productId) async {
    try {
      return await _apiService.getById(productId: productId);
    } catch (e) {
      throw e;
    }
  }
}
