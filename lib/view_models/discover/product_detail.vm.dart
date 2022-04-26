import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../app/app.locator.dart';
import '../../app/app.router.dart';
import '../../app/app_router.dart';
import '../../models/app_navigator.dart';
import '../../models/failure_exception.dart';
import '../../models/post_requests/shared/application_log.dart';
import '../../models/product.dart';
import '../../models/shop.dart';
import '../../providers/auth.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../providers/wishlist.dart';
import '../../screens/discover/product_reviews.dart';
import '../../screens/discover/report_product.dart';
import '../../screens/profile/shop/user_shop.dart';
import '../../services/application_logger.dart';
import '../../services/bottom_nav_bar_hider.dart';
import '../../state/view_model.dart';
import '../../utils/constants/themes.dart';
import '../../utils/functions.utils.dart';
import '../../utils/repeated_days_generator/schedule_generator.dart';

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

  late final bool open;
  late final String? nearestDate;

  bool get isLiked => product.likes.contains(context.read<Auth>().user?.id);
  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    super.init();
    _checkDateAvailability();
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
    context.read<ApplicationLogger>().log(
      actionType: ActionTypes.productView,
      metaData: {
        'product_id': product.id,
        'shop_id': shop.id,
      },
    );
  }

  void _checkDateAvailability() {
    final _selectableDates = ScheduleGenerator()
        .generateSchedule(product.availability)
        .selectableDates;

    final _now = DateTime.now();

    open = _selectableDates.any((date) =>
            date.year == _now.year &&
            date.month == _now.month &&
            // ignore: require_trailing_commas
            _now.day == date.day) &&
        _isInOperatingHours();

    if (open) return;

    final _nearestAvailableDate = _selectableDates.reduce((a, b) {
      if (a.difference(_now).isNegative) {
        return b;
      }
      return a;
    });
    nearestDate = 'Nearest date: '
        '${DateFormat('MMMM dd').format(_nearestAvailableDate)}';
  }

  bool _isInOperatingHours() {
    final _now = DateTime.now();
    final _opening = stringToTimeOfDay(shop.operatingHours.startTime);
    final _closing = stringToTimeOfDay(shop.operatingHours.endTime);
    final _timeNow = TimeOfDay.fromDateTime(_now);

    final _openingInMinutes = (_opening.hour * 60) + _opening.minute;
    final _closingInMinutes = (_closing.hour * 60) + _closing.minute;
    final _nowInMinutes = (_timeNow.hour * 60) + _timeNow.minute;

    return _openingInMinutes <= _nowInMinutes &&
        _nowInMinutes <= _closingInMinutes;
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
    _appRouter.navigateTo(
      AppRoute.discover,
      DiscoverRoutes.subscriptionScheduleCreate,
      arguments: SubscriptionScheduleCreateArguments(productId: product.id),
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
      return _appRouter.navigateTo(
        AppRoute.profile,
        ProfileScreenRoutes.userShop,
        arguments: UserShopArguments(
          userId: product.userId,
          shopId: product.shopId,
        ),
      );
    }

    final appRoute = _appRouter.currentTabRoute;
    return _appRouter.pushDynamicScreen(
      appRoute,
      AppNavigator.appPageRoute(
        builder: (_) => UserShop(
          userId: product.userId,
          shopId: product.shopId,
        ),
      ),
    );
  }

  void onLike() {
    try {
      if (isLiked) {
        context.read<Products>().unlikeProduct(
              productId: product.id,
              userId: context.read<Auth>().user!.id,
            );
        product.likes.remove(context.read<Auth>().user!.id);
        showToast('Unliked!');
      } else {
        context
          ..read<Products>().likeProduct(
            productId: product.id,
            userId: context.read<Auth>().user!.id,
          )
          ..read<ApplicationLogger>().log(
            actionType: ActionTypes.productLike,
            metaData: {
              'product_id': product.id,
              'shop_id': shop.id,
            },
          );

        product.likes.add(context.read<Auth>().user!.id);
        showToast('Liked!');
      }
      notifyListeners();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      showToast(e is FailureException ? e.message : e.toString());
    }
  }

  void onReport() {
    final _route = _appRouter.currentTabRoute;
    _appRouter.pushDynamicScreen(
      _route,
      AppNavigator.appPageRoute(
        builder: (_) => ReportProduct(productId: product.id),
      ),
    );
  }

  void viewReviews() {
    final _route = _appRouter.currentTabRoute;
    _appRouter.pushDynamicScreen(
      _route,
      AppNavigator.appPageRoute(
        builder: (_) => ProductReviews(productId: product.id),
      ),
    );
  }
}
