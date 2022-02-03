import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../services/api/api.dart';
import '../services/api/product_api_service.dart';

class UserWishlist extends ChangeNotifier {
  factory UserWishlist(API api) {
    return UserWishlist._(ProductApiService(api));
  }
  UserWishlist._(this._apiService);

  final ProductApiService _apiService;

  List<String> _wishList = [];
  List<String> get items => _wishList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _userId;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void onUserChanged(String? value) {
    if (_userId == value) return;
    _userId = value;

    if (value != null) {
      fetchWishlist();
    }
  }

  Future<void> fetchWishlist() async {
    if (_userId == null) return;
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final _products = await _apiService.getUserWishlist(userId: _userId!);
      _wishList = _products.map<String>((product) => product.id).toList();
    } catch (e, stack) {
      _errorMessage = 'Error fetching wishlist, try again.';

      // No rethrows as it is used in [main.dart]
      FirebaseCrashlytics.instance.recordError(e, stack);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToWishlist({required String productId}) async {
    try {
      if (_wishList.contains(productId)) {
        throw 'Product already added to wishlist!';
      }
      _wishList.add(productId);
      notifyListeners();

      final success = await _apiService.addToWishlist(productId: productId);
      return success;
    } catch (e) {
      _wishList.remove(productId);
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> removeFromWishlist({required String productId}) async {
    try {
      if (!_wishList.contains(productId)) {
        throw 'Product not found in wishlist!';
      }

      _wishList.remove(productId);
      notifyListeners();

      return await _apiService.removeFromWishlist(
        productId: productId,
      );
    } catch (e) {
      _wishList.add(productId);
      notifyListeners();
      rethrow;
    }
  }
}
