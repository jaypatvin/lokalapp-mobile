import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../models/lokal_user.dart';
import '../../../models/user_shop.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../routers/app_router.dart';
import '../../../routers/profile/user_shop.props.dart';
import '../../../screens/profile/add_shop/add_shop.dart';
import '../../../screens/profile/shop/user_shop.dart';
import '../../../widgets/verification/verify_screen.dart';

enum ShopBannerMode {
  currentUser,
  otherUserNoShop,
  otherUserWithShop,
}

class ShopBannerViewModel extends ChangeNotifier {
  ShopBannerViewModel(this.context, this.userId);
  final BuildContext context;
  final String userId;

  // late final bool isUserRegistered;
  late final bool isCurrentUser;
  late final LokalUser user;

  ShopModel? shop;
  bool isUserRegistered = false;
  ShopBannerMode mode = ShopBannerMode.currentUser;

  void init() {
    this.isCurrentUser = context.read<Auth>().user!.id == userId;
    _userSetup();
    _shopSetup();
    this.user = isCurrentUser
        ? context.read<Auth>().user!
        : context.read<Users>().findById(userId)!;
  }

  void _shopSetup() {
    final shops = context.read<Shops>().findByUser(userId);
    if (shops.isNotEmpty) this.shop = shops.first;

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
    this.isUserRegistered = context.read<Auth>().user!.registration != null &&
        context.read<Auth>().user!.registration!.verified != null &&
        context.read<Auth>().user!.registration!.verified!;
  }

  void onAddShop() {
    AppRouter.profileNavigatorKey.currentState?.push(
      CupertinoPageRoute(
        builder: (_) => AddShop(),
      ),
    );
  }

  void onVerify() {
    AppRouter.profileNavigatorKey.currentState?.push(
      CupertinoPageRoute(
        builder: (_) => VerifyScreen(
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
