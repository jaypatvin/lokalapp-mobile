import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../screens/profile/settings/invite_a_friend/invite_a_friend.dart';

class CurrentUserProfileViewModel extends ChangeNotifier {
  CurrentUserProfileViewModel(this.context);

  final BuildContext context;
  final pageController = PageController(initialPage: 0);

  Future<bool> onWillPop() async {
    if (pageController.page == 0)
      return true;
    else {
      pageController.animateToPage(
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
    pageController.animateToPage(
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

  void onNotificationsTap() => null;
  void onWishlistTap() => null;
}
