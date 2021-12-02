import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../screens/profile/settings/invite_a_friend/invite_a_friend.dart';
import '../../../state/view_model.dart';

class CurrentUserProfileViewModel extends ViewModel {
  CurrentUserProfileViewModel(this._pageController);

  final PageController _pageController;

  Future<bool> onWillPop() async {
    if (_pageController.page == 0)
      return true;
    else {
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
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => InviteAFriend(),
      ),
    );
  }

  void onWishlistTap() => null;
}
