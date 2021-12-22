import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/failure_exception.dart';
import '../../../models/lokal_images.dart';
import '../../../models/lokal_user.dart';
import '../../../models/user_shop.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../routers/app_router.dart';
import '../../../screens/profile/add_shop/edit_shop.dart';
import '../../../screens/profile/profile_screen.dart';
import '../../../screens/profile/settings/settings.dart';
import '../../../state/view_model.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/functions.utils.dart';

class UserShopViewModel extends ViewModel {
  UserShopViewModel(this.userId, [this.shopId]);

  final String userId;
  final String? shopId;

  late final bool isCurrentUser;
  late final LokalUser user;
  late ShopModel shop;

  List<Color> get shopHeaderColors => isCurrentUser
      ? const [Color(0xffFFC700), Colors.black45]
      : const [kPinkColor, Colors.black45];

  bool get displaySettingsButton => isCurrentUser;
  bool get displayEditButton => isCurrentUser;

  @override
  void init() {
    _shopSetup();
    this.isCurrentUser = context.read<Auth>().user!.id! == this.userId;
    this.user = isCurrentUser
        ? context.read<Auth>().user!
        : context.read<Users>().findById(userId)!;
  }

  void _shopSetup() {
    ShopModel? _shop;

    if (shopId != null) {
      _shop = context.read<Shops>().findById(shopId);
    }

    if (shopId == null && _shop == null) {
      final _shops = context.read<Shops>().findByUser(userId);
      if (_shops.isEmpty) throw 'Error: no shop found.';

      _shop = _shops.first;
    }

    if (_shop == null) throw FailureException('Error: no shop found.');
    this.shop = _shop;
  }

  void refresh() {
    _shopSetup();
    notifyListeners();
  }

  void onSettingsTap() {
    AppRouter.profileNavigatorKey.currentState?.pushNamed(Settings.routeName);
  }

  void onEditTap() {
    AppRouter.profileNavigatorKey.currentState?.pushNamed(EditShop.routeName);
  }

  void onShopPhotoTap() {
    if (shop.profilePhoto != null) {
      openGallery(
        context,
        0,
        [
          LokalImages(
            url: shop.profilePhoto!,
            order: 0,
          ),
        ],
      );
    }
  }

  void goToProfile() {
    if (isCurrentUser) {
      context.read<AppRouter>()
        ..jumpToTab(AppRoute.profile)
        ..keyOf(AppRoute.profile).currentState?.popUntil(
              (route) => route.isFirst,
            );
    } else {
      context.read<AppRouter>()
        ..keyOf(AppRoute.profile).currentState?.popUntil(
              (route) => route.isFirst,
            )
        ..navigateTo(
          AppRoute.profile,
          ProfileScreen.routeName,
          arguments: {'userId': user.id!},
        );
    }
  }
}
