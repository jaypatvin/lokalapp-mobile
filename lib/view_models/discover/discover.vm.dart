import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/failure_exception.dart';
import '../../models/product.dart';
import '../../providers/auth.dart';
import '../../providers/products.dart';
import '../../providers/shops.dart';
import '../../services/api/api.dart';
import '../../services/api/product_api_service.dart';
import '../../state/view_model.dart';

class DiscoverViewModel extends ViewModel {
  late final ProductApiService _apiService;
  final _appRouter = locator<AppRouter>();

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

  late final Products _productsProvider;
  late final Shops _shopsProvider;

  @override
  void init() {
    _apiService = ProductApiService(context.read<API>());
    _productsProvider = context.read<Products>();
    _shopsProvider = context.read<Shops>();
    fetchRecommendedProducts();
    _productsProvider.addListener(_refresh);
    _shopsProvider.addListener(_refresh);
  }

  @override
  void dispose() {
    _productsProvider.removeListener(_refresh);
    _shopsProvider.removeListener(_refresh);
    super.dispose();
  }

  Future<void> fetchRecommendedProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = context.read<Auth>().user!;
      _recommendedProducts = await _apiService.getRecommendedProducts(
        userId: user.id,
        communityId: user.communityId,
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onProductTap(String id) {
    final product = context.read<Products>().findById(id);
    _appRouter.navigateTo(
      AppRoute.discover,
      DiscoverRoutes.productDetail,
      arguments: ProductDetailArguments(product: product!),
    );
  }

  void onExploreCategories() {
    _appRouter.navigateTo(
      AppRoute.discover,
      DiscoverRoutes.exploreCategories,
    );
  }

  void onSearch() {
    _appRouter.navigateTo(
      AppRoute.discover,
      DiscoverRoutes.search,
    );
  }

  Future<void> _refresh() async {
    if (!recommendedProducts.every(
      (product) => otherUserProducts.any((other) => other.id == product.id),
    )) {
      return fetchRecommendedProducts();
    }
  }
}
