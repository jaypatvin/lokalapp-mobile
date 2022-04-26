import 'package:provider/provider.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../app/app_router.dart';
import '../../../models/app_navigator.dart';
import '../../../models/shop.dart';
import '../../../providers/auth.dart';
import '../../../screens/profile/shop/user_shop.dart';
import '../../../state/view_model.dart';

class ShopBannerViewModel extends ViewModel {
  ShopBannerViewModel({required this.userId});
  final String userId;

  late final bool isCurrentUser;
  final _appRouter = locator<AppRouter>();

  @override
  void init() {
    isCurrentUser = context.read<Auth>().user!.id == userId;
  }

  void onAddShop() {
    // The current user can only view this on the profile screen.
    _appRouter.navigateTo(AppRoute.profile, ProfileScreenRoutes.addShop);
  }

  void onVerify() {
    // The current user can only view this on the profile screen.
    _appRouter.navigateTo(
      AppRoute.profile,
      ProfileScreenRoutes.verifyScreen,
      arguments: VerifyScreenArguments(
        skippable: false,
      ),
    );
  }

  Future<dynamic> goToShop(Shop shop) async {
    if (isCurrentUser) {
      return _appRouter.navigateTo(
        AppRoute.profile,
        ProfileScreenRoutes.userShop,
        arguments: UserShopArguments(userId: userId, shopId: shop.id),
      );
    }

    final appRoute = _appRouter.currentTabRoute;
    return _appRouter.pushDynamicScreen(
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
