import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/failure_exception.dart';
import '../models/product.dart';
import '../services/api/api.dart';
import '../services/api/product_api_service.dart';
import '../services/database.dart';

class Products extends ChangeNotifier {
  factory Products(API api) {
    return Products._(ProductApiService(api));
  }

  Products._(this._apiService);

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

  Future<void> _productListener(
    QuerySnapshot<Map<String, dynamic>> query,
  ) async {
    final length = query.docChanges.length;
    if (_isLoading || length > 1) return;
    for (final change in query.docChanges) {
      final id = change.doc.id;
      final index = _products.indexWhere((p) => p.id == id);

      if (index >= 0) {
        try {
          _products[index] = await _apiService.getById(productId: id);
          _products[index].likes = await _db.getProductLikes(id);
        } catch (e) {
          if (e is FailureException && e.details is http.Response) {
            if ((e.details! as http.Response).statusCode == 404) {
              _products.removeAt(index);
            }
          }
        }
        notifyListeners();
        return;
      }

      final product = await _apiService.getById(productId: id);
      _products.add(product);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }

  Product? findById(String? id) {
    return _products.firstWhereOrNull(
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
      for (final product in _products) {
        product.likes = await _db.getProductLikes(product.id);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> create(Map<String, dynamic> body) async {
    try {
      await _apiService.create(body: body);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _apiService.update(productId: id, body: data);
    } catch (e) {
      rethrow;
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
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _apiService.deleteProduct(productId: productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> fetchProductById(String productId) async {
    try {
      return await _apiService.getById(productId: productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likeProduct({
    required String productId,
    required String userId,
  }) async {
    final product = findById(productId);
    product!.likes.add(userId);
    notifyListeners();

    try {
      await _apiService.like(productId: productId);
    } catch (e) {
      product.likes.remove(userId);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> unlikeProduct({
    required String productId,
    required String userId,
  }) async {
    final product = findById(productId);
    product!.likes.remove(userId);
    notifyListeners();

    try {
      await _apiService.unlike(productId: productId);
    } catch (e) {
      product.likes.add(userId);
      notifyListeners();
      rethrow;
    }
  }
}
