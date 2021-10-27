import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../../../providers/products.dart';
import '../../../../screens/discover/product_detail.dart';
import '../../../../screens/profile/add_product/product_details.dart';
import '../../../../screens/profile/add_product/add_product.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../models/lokal_user.dart';
import '../../../../models/product.dart';
import '../../../../models/user_shop.dart';
import '../../../../providers/auth.dart';
import '../../../../providers/shops.dart';
import '../../../../providers/users.dart';

class ShopProductFieldViewModel extends ChangeNotifier {
  ShopProductFieldViewModel(
    this.context,
    this.userId, [
    this._products = const [],
    this.shopId,
  ]);

  final BuildContext context;
  final String userId;
  final String? shopId;

  late final bool isCurrentUser;
  late final ShopModel shop;
  late final LokalUser user;

  List<Product> _products;
  UnmodifiableListView<Product> get products => UnmodifiableListView(
      _products.where((product) => product.shopId == shop.id));

  void init() {
    this.isCurrentUser = context.read<Auth>().user!.id! == this.userId;
    this.user = isCurrentUser
        ? context.read<Auth>().user!
        : context.read<Users>().findById(userId);

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
    this.shop = _shop;

    _products = context.read<Products>().findByShop(this.shop.id!);
  }

  void updateProducts(List<Product> products) {
    _products = [...products];
    notifyListeners();
  }

  void addProduct() {
    pushNewScreen(context, screen: AddProduct());
  }

  void onProductTap(String id) {
    final product = _products.firstWhereOrNull((p) => p.id == id);
    if (product == null) throw 'Product does not exist!';
    pushNewScreen(
      context,
      screen: isCurrentUser
          ? AddProduct(
              productId: product.id,
            )
          : ProductDetail(product),
    );
  }
}
