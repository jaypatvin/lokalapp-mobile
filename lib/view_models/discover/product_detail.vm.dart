import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../models/app_navigator.dart';
import '../../models/failure_exception.dart';
import '../../models/product.dart';
import '../../models/shop.dart';
import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../../providers/wishlist.dart';
import '../../routers/app_router.dart';
import '../../routers/profile/props/user_shop.props.dart';
import '../../screens/activity/subscriptions/subscription_schedule.dart';
import '../../screens/profile/shop/user_shop.dart';
import '../../services/bottom_nav_bar_hider.dart';
import '../../state/view_model.dart';
import '../../utils/constants/themes.dart';

class ProductDetailViewModel extends ViewModel {
  ProductDetailViewModel({
    required this.product,
    required this.cart,
    required this.shop,
  });

  final ShoppingCart cart;
  final Product product;
  final Shop shop;

  late final String appBarTitle;
  late String _buttonLabel;
  late Color _buttonColor;

  String _instructions = '';
  String get instructions => _instructions;

  int _quantity = 1;
  int get quantity => _quantity;

  String get buttonLabel => _buttonLabel;
  Color get buttonColor => _buttonColor;

  bool get available => product.quantity > 0;

  @override
  void init() {
    super.init();
    if (cart.contains(product.id)) {
      final order = cart.getProductOrder(product.id)!;
      _instructions = order.notes ?? '';
      _quantity = order.quantity;
      appBarTitle = 'Edit Order';
      _buttonLabel = 'UPDATE CART';
    } else {
      appBarTitle = shop.name;
      _buttonLabel = 'ADD TO CART';
    }
    _buttonColor = kTealColor;
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
    _updateButton();

    _quantity++;
    notifyListeners();
  }

  void decrease() {
    if (quantity <= 0) return;

    _quantity--;
    if (_quantity == 0) {
      if (cart.contains(product.id)) {
        _buttonLabel = 'REMOVE FROM CART';
        _buttonColor = kPinkColor;
      }
    } else {
      _updateButton();
    }
    notifyListeners();
  }

  void _updateButton() {
    if (_buttonLabel != 'UPDATE CART' && cart.contains(product.id)) {
      _buttonLabel = 'UPDATE CART';
      _buttonColor = kTealColor;
    }
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

  void onSubscribe() {
    context.read<AppRouter>().pushDynamicScreen(
          AppRoute.discover,
          AppNavigator.appPageRoute(
            builder: (_) => SubscriptionSchedule.create(
              productId: product.id,
            ),
          ),
        );
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
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
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

  Future<dynamic> goToShop() async {
    context.read<BottomNavBarHider>().isHidden = false;

    if (context.read<Auth>().user?.id == product.userId) {
      return context.read<AppRouter>().navigateTo(
            AppRoute.profile,
            UserShop.routeName,
            arguments: UserShopProps(product.userId, product.shopId),
          );
    }

    final appRoute = context.read<AppRouter>().currentTabRoute;
    return context.read<AppRouter>().pushDynamicScreen(
          appRoute,
          AppNavigator.appPageRoute(
            builder: (_) => UserShop(
              userId: product.userId,
              shopId: product.shopId,
            ),
          ),
        );
  }
}
