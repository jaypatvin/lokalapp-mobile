import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routers/app_router.dart';
import '../../../screens/profile/settings/invite_a_friend/invite_a_friend.dart';
import '../../../screens/profile/wishlist_screen.dart';
import '../../../state/view_model.dart';

class CurrentUserProfileViewModel extends ViewModel {
  CurrentUserProfileViewModel(this._pageController);

  final PageController _pageController;

  Future<bool> onWillPop() async {
    if (_pageController.page == 0) {
      return true;
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
      return false;
    }
  }

  void onPanUpdate(DragUpdateDetails data) {
    if (data.delta.dx > 0) {
      Navigator.maybePop(context);
    }
  }

  void onMyPostsTap() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  void onInviteFriend() {
    context.read<AppRouter>().navigateTo(
          AppRoute.profile,
          InviteAFriend.routeName,
        );
  }

  void onWishlistTap() {
    context.read<AppRouter>().navigateTo(
          AppRoute.profile,
          WishlistScreen.routeName,
        );
  }
}
