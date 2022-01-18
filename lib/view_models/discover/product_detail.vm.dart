import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../models/user_shop.dart';
import '../../providers/cart.dart';
import '../../providers/wishlist.dart';
import '../../routers/app_router.dart';
import '../../routers/profile/user_shop.props.dart';
import '../../screens/profile/shop/user_shop.dart';
import '../../services/bottom_nav_bar_hider.dart';
import '../../state/view_model.dart';

class ProductDetailViewModel extends ViewModel {
  ProductDetailViewModel({
    required this.product,
    required this.cart,
    required this.shop,
  });

  final ShoppingCart cart;
  final Product product;
  final ShopModel shop;

  late final String appBarTitle;
  late final String buttonLabel;

  String _instructions = '';
  String get instructions => _instructions;

  int _quantity = 0;
  int get quantity => _quantity;

  bool get available => product.quantity > 0;

  @override
  void init() {
    super.init();
    if (cart.contains(product.id)) {
      final order = cart.getProductOrder(product.id)!;
      _instructions = order.notes ?? '';
      _quantity = order.quantity;
      appBarTitle = 'Edit Order';
      buttonLabel = 'UPDATE CART';
    } else {
      appBarTitle = shop.name!;
      buttonLabel = 'ADD TO CART';
    }
  }

  void onInstructionsChanged(String value) {
    _instructions = value;
    notifyListeners();
  }

  void increase() {
    if (product.quantity <= quantity) {
      showToast("You've reached the maximum number of possible orders.");
      return;
    }

    _quantity++;
    notifyListeners();
  }

  void decrease() {
    if (quantity <= 0) return;
    _quantity--;
    notifyListeners();
  }

  void onSubmit() {
    cart.add(
      shopId: product.shopId,
      productId: product.id,
      quantity: _quantity,
      notes: _instructions,
    );
    Navigator.pop(context);
  }

  Future<void> onWishlistPressed() async {
    try {
      final _wishlist = context.read<UserWishlist>();
      if (_wishlist.items.contains(product.id)) {
        final success = await _removeFromWishlist();
        showToast('Successfully removed from wishlist!');

        if (!success) throw 'Error removing from wishlist.';
        return;
      }
      final success = await _addToWishlist();
      showToast('Successfully added to wishlist!');
      if (!success) throw 'Error adding to wishlist.';
      return;
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<bool> _removeFromWishlist() async {
    try {
      return await context
          .read<UserWishlist>()
          .removeFromWishlist(productId: product.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _addToWishlist() async {
    try {
      return await context
          .read<UserWishlist>()
          .addToWishlist(productId: product.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> goToShop() async {
    context.read<BottomNavBarHider>().isHidden = false;
    await context.read<AppRouter>().navigateTo(
          AppRoute.profile,
          UserShop.routeName,
          arguments: UserShopProps(product.userId, product.shopId),
        );
  }
}
