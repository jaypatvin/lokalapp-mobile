import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/shop.dart';
import '../../../providers/auth.dart';
import '../../../routers/app_router.dart';
import '../../../routers/profile/props/user_shop.props.dart';
import '../../../screens/profile/add_shop/add_shop.dart';
import '../../../screens/profile/shop/user_shop.dart';
import '../../../state/view_model.dart';
import '../../../widgets/verification/verify_screen.dart';

class ShopBannerViewModel extends ViewModel {
  ShopBannerViewModel({required this.userId});
  final String userId;

  late final bool isCurrentUser;


  @override
  void init() {
    isCurrentUser = context.read<Auth>().user!.id == userId;
  }

  void onAddShop() {
    // The current user can only view this on the profile screen.
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => const AddShop(),
      ),
    );
  }

  void onVerify() {
    // The current user can only view this on the profile screen.
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => const VerifyScreen(
          skippable: false,
        ),
      ),
    );
  }

  Future<dynamic> goToShop(Shop shop) async {
    if (isCurrentUser) {
      return context.read<AppRouter>().navigateTo(
            AppRoute.profile,
            UserShop.routeName,
            arguments: UserShopProps(userId, shop.id),
          );
    }

    final appRoute = context.read<AppRouter>().currentTabRoute;
    return context.read<AppRouter>().pushDynamicScreen(
          appRoute,
          AppNavigator.appPageRoute(
            builder: (_) => UserShop(
              userId: userId,
              shopId: shop.id,
            ),
          ),
        );
  }
}
