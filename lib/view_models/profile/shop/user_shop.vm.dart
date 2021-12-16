import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/failure_exception.dart';
import '../../../models/lokal_user.dart';
import '../../../models/user_shop.dart';
import '../../../providers/auth.dart';
import '../../../providers/shops.dart';
import '../../../providers/users.dart';
import '../../../routers/app_router.dart';
import '../../../screens/profile/profile_screen.dart';
import '../../../state/view_model.dart';
import '../../../utils/constants/themes.dart';

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

  void onSettingsTap() {}
  void onEditTap() {}

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
