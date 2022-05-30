import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../models/post_requests/product/product_create.request.dart';
import '../models/post_requests/product/product_review.request.dart';
import '../models/post_requests/product/product_update.request.dart';
import '../models/post_requests/shop/operating_hours.request.dart';
import '../models/product.dart';
import '../services/api/api.dart';
import '../services/api/product_api_service.dart';
import '../services/database/collections/products.collection.dart';
import '../services/database/database.dart';

class Products extends ChangeNotifier {
  factory Products(API api, Database database) {
    return Products._(ProductApiService(api), database.products);
  }

  Products._(this._apiService, this._db);

  final ProductsCollection _db;
  final ProductApiService _apiService;

  final _products = <Product>[];

  String? _communityId;
  bool _isLoading = false;

  Stream<List<Product>>? _productsStream;
  Stream<List<Product>>? get stream => _productsStream;
  StreamSubscription<List<Product>>? _productsSubscription;
  StreamSubscription<List<Product>>? get subscriptionListener =>
      _productsSubscription;

  UnmodifiableListView<Product> get items => UnmodifiableListView(
        _products.where((product) => !product.archived),
      );

  bool get isLoading => _isLoading;
  String? get communityId => _communityId;

  void setCommunityId(String? id) {
    if (id == _communityId) return;

    _communityId = id;
    if (_communityId == null) {
      _productsSubscription?.cancel();
      _products.clear();
      if (hasListeners) notifyListeners();
      return;
    }

    if (id != null) {
      _isLoading = true;
      if (hasListeners) notifyListeners();
      _productsSubscription?.cancel();
      _productsStream = _db.getCommunityProducts(id);
      _productsSubscription = _productsStream?.listen(_productListener);
    }
  }

  Future<void> _productListener(List<Product> products) async {
    log('updated');
    // _products.clear();
    for (final product in products) {
      final _product = product.copyWith(
        likes: await _db.getProductLikes(product.id),
      );
      // _products.add(_product);
      final index =
          _products.indexWhere((element) => element.id == _product.id);

      if (index == -1) {
        _products.add(_product);
      } else {
        _products[index] = _product;
      }
    }
    _isLoading = false;
    if (hasListeners) notifyListeners();
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

  Future<void> create(ProductCreateRequest request) async {
    try {
      await _apiService.create(request: request);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> update({
    required String id,
    required ProductUpdateRequest request,
  }) async {
    try {
      return await _apiService.update(productId: id, request: request);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setAvailability({
    required String id,
    required OperatingHoursRequest request,
  }) async {
    try {
      return await _apiService.setAvailability(
        productId: id,
        request: request,
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

  Future<bool> addReview({
    required String productId,
    required String orderId,
    required int rating,
    String? message,
  }) async {
    try {
      return await _apiService.review(
        productId: productId,
        request: ProductReviewRequest(
          orderId: orderId,
          rating: rating,
          message: message,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
