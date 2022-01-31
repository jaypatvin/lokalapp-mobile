import 'dart:async';

import 'package:collection/collection.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../routers/app_router.dart';
import '../../routers/discover/product_detail.props.dart';
import '../../screens/discover/explore_categories.dart';
import '../../screens/discover/product_detail.dart';
import '../../screens/discover/search.dart';
import '../../services/api/api.dart';
import '../../services/api/product_api_service.dart';
import '../../state/view_model.dart';

class DiscoverViewModel extends ViewModel {
  late final ProductApiService _apiService;

  List<Product> _recommendedProducts = [];
  UnmodifiableListView<Product> get recommendedProducts {
    final cUser = context.read<Auth>().user!;

    if (_recommendedProducts.isNotEmpty) {
      return UnmodifiableListView(
        _recommendedProducts.where(
          (product) => product.userId != cUser.id,
        ),
      );
    }

    return UnmodifiableListView(
      context.read<Products>().items.where((p) => p.userId != cUser.id).toList()
        ..shuffle(),
    );
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

  @override
  void init() {
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
      showToast(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onProductTap(String id) {
    final product = context.read<Products>().findById(id);
    context.read<AppRouter>().navigateTo(
          AppRoute.discover,
          ProductDetail.routeName,
          arguments: ProductDetailProps(product!),
        );
  }

  void onExploreCategories() {
    context.read<AppRouter>().navigateTo(
          AppRoute.discover,
          ExploreCategories.routeName,
        );
  }

  void onSearch() {
    context.read<AppRouter>().navigateTo(
          AppRoute.discover,
          Search.routeName,
        );
  }
}
