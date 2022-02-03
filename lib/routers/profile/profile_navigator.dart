import 'package:flutter/widgets.dart';

import '../../models/app_navigator.dart';
import '../../screens/profile/add_product/add_product.dart';
import '../../screens/profile/add_shop/add_shop.dart';
import '../../screens/profile/add_shop/customize_availability.dart';
import '../../screens/profile/add_shop/edit_shop.dart';
import '../../screens/profile/add_shop/payment_options.dart';
import '../../screens/profile/add_shop/shop_confirmation.dart';
import '../../screens/profile/add_shop/shop_schedule.dart';
import '../../screens/profile/edit_profile.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/settings/invite_a_friend/invite_a_friend.dart';
import '../../screens/profile/settings/settings.dart';
import '../../screens/profile/shop/user_shop.dart';
import '../../screens/profile/wishlist_screen.dart';
import 'props/customize_availability.props.dart';
import 'props/payment_options.props.dart';
import 'props/shop_schedule.props.dart';
import 'props/user_shop.props.dart';

class ProfileNavigator extends AppNavigator {
  const ProfileNavigator(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey);

  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ProfileScreen.routeName:
        final userId = (settings.arguments! as Map<String, String>)['userId']!;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => ProfileScreen(
            userId: userId,
          ),
        );
      case EditProfile.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => const EditProfile(),
        );
      case Settings.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => Settings(),
        );

      case UserShop.routeName:
        final props = settings.arguments! as UserShopProps;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => UserShop(
            userId: props.userId,
            shopId: props.shopId,
          ),
        );

      case AddShop.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => const AddShop(),
        );
      case ShopSchedule.routeName:
        final props = settings.arguments! as ShopScheduleProps;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => ShopSchedule(
            shopPhoto: props.shopPhoto,
            forEditing: props.forEditing,
            onShopEdit: props.onShopEdit,
          ),
        );
      case CustomizeAvailability.routeName:
        final props = settings.arguments! as CustomizeAvailabilityProps;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => CustomizeAvailability(
            repeatChoice: props.repeatChoice,
            selectableDays: props.selectableDays,
            startDate: props.startDate,
            repeatEvery: props.repeatEvery,
            usedDatePicker: props.usedDatePicker,
            shopPhoto: props.shopPhoto,
            forEditing: props.forEditing,
            onShopEdit: props.onShopEdit,
          ),
        );
      case SetUpPaymentOptions.routeName:
        final props = settings.arguments! as SetUpPaymentOptionsProps;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => props.edit
              ? SetUpPaymentOptions.edit(onSubmit: props.onSubmit)
              : SetUpPaymentOptions.create(onSubmit: props.onSubmit),
        );
      case AddShopConfirmation.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => AddShopConfirmation(),
        );

      case AddProduct.routeName:
        final productId = settings.arguments != null
            ? (settings.arguments! as Map<String, String>)['productId']
            : null;
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => AddProduct(
            productId: productId,
          ),
        );

      case WishlistScreen.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => const WishlistScreen(),
        );

      case InviteAFriend.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => const InviteAFriend(),
        );

      case EditShop.routeName:
        return AppNavigator.appPageRoute(
          settings: settings,
          builder: (_) => const EditShop(),
        );
      default:
        // TODO: implement unknownRoute
        throw UnimplementedError();
    }
  }
}
