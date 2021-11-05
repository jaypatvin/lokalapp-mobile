import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../models/lokal_user.dart';
import '../../../models/user_shop.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
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
        : context.read<Users>().findById(userId);
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
    pushNewScreen(
      context,
      screen: AddShop(),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  void onVerify() {
    pushNewScreen(
      context,
      screen: VerifyScreen(
        skippable: false,
      ),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  void goToShop() {
    pushNewScreenWithRouteSettings(
      context,
      screen: UserShop(userId: userId),
      settings: RouteSettings(name: UserShop.routeName),
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  void refresh() {
    _shopSetup();
    _userSetup();
    notifyListeners();
  }
}
