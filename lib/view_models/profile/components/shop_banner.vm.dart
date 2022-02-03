import 'package:provider/provider.dart';

import '../../../models/app_navigator.dart';
import '../../../models/lokal_user.dart';
import '../../../models/shop.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../routers/app_router.dart';
import '../../../routers/profile/props/user_shop.props.dart';
import '../../../screens/profile/add_shop/add_shop.dart';
import '../../../screens/profile/shop/user_shop.dart';
import '../../../state/view_model.dart';
import '../../../widgets/verification/verify_screen.dart';

enum ShopBannerMode {
  currentUser,
  otherUserNoShop,
  otherUserWithShop,
}

class ShopBannerViewModel extends ViewModel {
  ShopBannerViewModel({required this.userId});
  final String userId;

  late final bool isCurrentUser;
  late LokalUser _user;
  LokalUser get user => _user;

  Shop? shop;
  ShopBannerMode mode = ShopBannerMode.currentUser;
  bool get isUserRegistered => _user.registration?.verified ?? false;

  @override
  void init() {
    isCurrentUser = context.read<Auth>().user!.id == userId;
    if (isCurrentUser) {
      _userSetup();
    } else {
      _user = context.read<Users>().findById(userId)!;
    }
    _shopSetup();
  }

  void _shopSetup() {
    final shops = context.read<Shops>().findByUser(userId);
    if (shops.isNotEmpty) shop = shops.first;

    if (!isCurrentUser) {
      if (shops.isEmpty) {
        mode = ShopBannerMode.otherUserNoShop;
      } else {
        mode = ShopBannerMode.otherUserWithShop;
      }
    } else {
      mode = ShopBannerMode.currentUser;
    }
  }

  void _userSetup() {
    _user = context.read<Auth>().user!;
  }

  void onAddShop() {
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => const AddShop(),
      ),
    );
  }

  void onVerify() {
    AppRouter.profileNavigatorKey.currentState?.push(
      AppNavigator.appPageRoute(
        builder: (_) => const VerifyScreen(
          skippable: false,
        ),
      ),
    );
  }

  void goToShop() {
    AppRouter.profileNavigatorKey.currentState?.pushNamed(
      UserShop.routeName,
      arguments: UserShopProps(userId),
    );
  }

  void refresh() {
    _shopSetup();
    _userSetup();
    notifyListeners();
  }
}
