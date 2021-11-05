import 'package:flutter/cupertino.dart';

import '../../models/app_navigator.dart';
import '../../screens/profile/add_product/add_product.dart';
import '../../screens/profile/add_shop/add_shop.dart';
import '../../screens/profile/add_shop/customize_availability.dart';
import '../../screens/profile/add_shop/payment_options.dart';
import '../../screens/profile/add_shop/shop_confirmation.dart';
import '../../screens/profile/add_shop/shop_schedule.dart';
import '../../screens/profile/edit_profile.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/settings/settings.dart';
import '../../screens/profile/shop/user_shop.dart';
import 'customize_availability.props.dart';
import 'shop_schedule.props.dart';

class ProfileNavigator extends AppNavigator {
  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ProfileScreen.routeName:
        final userId = (settings.arguments as Map<String, String>)['userId']!;
        return CupertinoPageRoute(
          builder: (_) => ProfileScreen(
            userId: userId,
          ),
        );
      case EditProfile.routeName:
        return CupertinoPageRoute(builder: (_) => EditProfile());
      case Settings.routeName:
        return CupertinoPageRoute(builder: (_) => Settings());

      case UserShop.routeName:
        final userId = (settings.arguments as Map<String, String>)['userId']!;
        return CupertinoPageRoute(builder: (_) => UserShop(userId: userId));

      case AddShop.routeName:
        return CupertinoPageRoute(builder: (_) => AddShop());
      case ShopSchedule.routeName:
        final props = settings.arguments as ShopScheduleProps;
        return CupertinoPageRoute(
          builder: (_) => ShopSchedule(
            props.shopPhoto,
            forEditing: props.forEditing,
            onShopEdit: props.onShopEdit,
          ),
        );
      case CustomizeAvailability.routeName:
        final props = settings.arguments as CustomizeAvailabilityProps;
        return CupertinoPageRoute(
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
        final onSubmit =
            (settings.arguments as Map<String, void Function()>)['onSubmit']!;
        return CupertinoPageRoute(
          builder: (_) => SetUpPaymentOptions(onSubmit: onSubmit),
        );
      case AddShopConfirmation.routeName:
        return CupertinoPageRoute(builder: (_) => AddShopConfirmation());

      case AddProduct.routeName:
        final productId =
            (settings.arguments as Map<String, String>)['productId'];
        return CupertinoPageRoute(
          builder: (_) => AddProduct(
            productId: productId,
          ),
        );
      default:
        // TODO: implement unknownRoute
        throw UnimplementedError();
    }
  }
}
