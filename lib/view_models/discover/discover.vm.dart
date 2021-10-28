import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../screens/discover/explore_categories.dart';
import '../../screens/discover/product_detail.dart';
import '../../screens/discover/search.dart';
import '../../services/api/api.dart';
import '../../services/api/product_api_service.dart';

class DiscoverViewModel extends ChangeNotifier {
  DiscoverViewModel(this.context);

  final BuildContext context;
  final StreamController<String> _errorStream = StreamController.broadcast();

  late final ProductApiService _apiService;

  List<Product> _recommendedProducts = [];
  UnmodifiableListView<Product> get recommendedProducts {
    if (_recommendedProducts.isNotEmpty)
      return UnmodifiableListView(_recommendedProducts);

    final items = [...context.read<Products>().items];
    return UnmodifiableListView(items..shuffle());
  }

  UnmodifiableListView<Product> get otherUserProducts {
    final cUser = context.read<Auth>().user!;
    return UnmodifiableListView(
      context.read<Products>().items.where((p) => p.userId != cUser.id).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isProductsLoading => context.read<Products>().isLoading;

  Stream<String> get errorStream => _errorStream.stream;

  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }

  void init() async {
    _apiService = ProductApiService(context.read<API>());
    fetchRecommendedProducts();
  }

  Future<void> fetchRecommendedProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = context.read<Auth>().user!;
      _recommendedProducts = await _apiService.getRecommendedProducts(
        userId: user.id!,
        communityId: user.communityId!,
      );
    } catch (e) {
      _errorStream.add(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onProductTap(String id) {
    final product = context.read<Products>().findById(id);
    pushNewScreen(
      context,
      screen: ProductDetail(product),
    );
  }

  void onExploreCategories() {
    pushNewScreen(context, screen: ExploreCategories());
  }

  void onSearch() {
    pushNewScreen(context, screen: Search());
  }
}