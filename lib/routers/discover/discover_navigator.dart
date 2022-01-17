import 'package:flutter/cupertino.dart';

import '../../models/app_navigator.dart';
import '../../screens/cart/cart_confirmation.dart';
import '../../screens/cart/checkout.dart';
import '../../screens/cart/checkout_cart.dart';
import '../../screens/cart/checkout_schedule.dart';
import '../../screens/cart/checkout_shop.dart';
import '../../screens/discover/discover.dart';
import '../../screens/discover/explore_categories.dart';
import '../../screens/discover/product_detail.dart';
import '../../screens/discover/search.dart';
import 'cart/checkout.props.dart';
import 'cart/checkout_schedule.props.dart';
import 'cart/checkout_shop.props.dart';
import 'product_detail.props.dart';

/// Includes navigation for both `Discover` and `Cart` screens.
///
/// We're putting the `Cart` navigation here since we want to navigate to the
/// `Discover` Tab when we view the `Cart`.
class DiscoverNavigator extends AppNavigator {
  const DiscoverNavigator(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey);

  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // DISCOVER SCREENS
      case Discover.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const Discover(),
        );
      case ExploreCategories.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExploreCategories(),
        );
      case ProductDetail.routeName:
        final props = settings.arguments! as ProductDetailProps;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ProductDetail(props.product),
        );
      case Search.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const Search(),
        );

      // CART SCREENS
      case CheckoutCart.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const CheckoutCart(),
        );
      case ShopCheckout.routeName:
        final props = settings.arguments! as ShopCheckoutProps;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ShopCheckout(shop: props.shop),
        );
      case Checkout.routeName:
        final props = settings.arguments! as CheckoutProps;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => Checkout(
            productId: props.productId,
          ),
        );
      case CheckoutSchedule.routeName:
        final props = settings.arguments! as CheckoutScheduleProps;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CheckoutSchedule(
            productId: props.productId,
          ),
        );
      case CartConfirmation.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const CartConfirmation(),
        );
      default:
        throw UnimplementedError();
    }
  }
}
