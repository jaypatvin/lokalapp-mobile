import 'package:flutter/cupertino.dart';
import 'package:lokalapp/models/user_shop.dart';
import 'package:lokalapp/providers/shops.dart';
import 'package:lokalapp/routers/app_router.dart';
import 'package:lokalapp/routers/profile/user_shop.props.dart';
import 'package:lokalapp/screens/profile/shop/user_shop.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/products.dart';

class ProductCardViewModel extends ChangeNotifier {
  ProductCardViewModel(this.context, this.productId);
  final BuildContext context;
  final String productId;

  bool _displayBorder = false;
  bool get displayBorder => _displayBorder;

  late final Product product;
  late final ShopModel shop;

  String? get productImage =>
      product.productPhoto ?? product.gallery?.first.url;
  String get productName => product.name;
  String get productPrice => product.basePrice.toString();
  String get productRating => product.avgRating.toString();

  void init() {
    product = context.read<Products>().findById(productId)!;
    shop = context.read<Shops>().findById(product.shopId)!;
  }

  void updateDisplayBorder(bool displayBorder) {
    this._displayBorder = displayBorder;
    notifyListeners();
  }

  void onLike() {
    print('Liked');
  }

  void onShopTap() {
    context.read<AppRouter>()
      ..navigateTo(
        AppRoute.profile,
        UserShop.routeName,
        arguments: UserShopProps(product.userId, product.shopId),
      );
  }
}
