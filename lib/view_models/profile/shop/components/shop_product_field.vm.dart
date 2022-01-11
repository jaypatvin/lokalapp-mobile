import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

import '../../../../models/lokal_user.dart';
import '../../../../models/product.dart';
import '../../../../models/user_shop.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/products.dart';
import '../../../../providers/shops.dart';
import '../../../../providers/users.dart';
import '../../../../routers/app_router.dart';
import '../../../../routers/discover/product_detail.props.dart';
import '../../../../screens/discover/product_detail.dart';
import '../../../../screens/profile/add_product/add_product.dart';
import '../../../../state/view_model.dart';

class ShopProductFieldViewModel extends ViewModel {
  ShopProductFieldViewModel({
    required this.userId,
    this.shopId,
  });

  final String userId;
  final String? shopId;

  late final bool isCurrentUser;
  late final ShopModel shop;
  late final LokalUser user;

  late List<Product> _products;
  UnmodifiableListView<Product> get products {
    if (_searchTerm?.isNotEmpty ?? false) {
      final items = UnmodifiableListView(
        _products.where(
          (product) => product.name.toLowerCase().contains(
                _searchTerm!.toLowerCase(),
              ),
        ),
      );
      return items;
    }

    return UnmodifiableListView(_products);
  }

  String? _searchTerm;
  String? get searchTerm => _searchTerm;

  @override
  void init() {
    isCurrentUser = context.read<Auth>().user!.id! == userId;
    user = isCurrentUser
        ? context.read<Auth>().user!
        : context.read<Users>().findById(userId)!;

    ShopModel? _shop;

    if (shopId != null) {
      _shop = context.read<Shops>().findById(shopId);
    }
    if (shopId == null && _shop == null) {
      final _shops = context.read<Shops>().findByUser(userId);
      if (_shops.isEmpty) throw 'Error: no shop found.';

      _shop = _shops.first;
    }

    if (_shop == null) throw 'Error: no shop found.';
    shop = _shop;

    _products = context.read<Products>().findByShop(shop.id!);
  }

  void updateProducts() {
    final _items = context.read<Products>().findByShop(shop.id!);
    _products = [..._items];
    notifyListeners();
  }

  void addProduct() {
    context
        .read<AppRouter>()
        .navigateTo(AppRoute.profile, AddProduct.routeName);
  }

  void onProductTap(String id) {
    final product = _products.firstWhereOrNull((p) => p.id == id);
    if (product == null) throw 'Product does not exist!';
    if (isCurrentUser) {
      context.read<AppRouter>().navigateTo(
        AppRoute.profile,
        AddProduct.routeName,
        arguments: {'productId': product.id},
      );
      return;
    }
    context.read<AppRouter>().navigateTo(
          AppRoute.discover,
          ProductDetail.routeName,
          arguments: ProductDetailProps(product),
        );
  }

  void onSearchTermChanged(String? value) {
    if (_searchTerm == value) return;
    _searchTerm = value;
    notifyListeners();
  }
}
