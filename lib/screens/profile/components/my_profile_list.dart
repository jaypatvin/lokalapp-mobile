import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/themes.dart';

class MyProfileList extends StatelessWidget {
  final void Function() onMyPostsTap;
  final void Function()? onNotificationsTap;
  final void Function()? onWishlistTap;
  final void Function()? onInviteFriend;
  const MyProfileList({
    Key? key,
    required this.onMyPostsTap,
    required this.onNotificationsTap,
    required this.onWishlistTap,
    required this.onInviteFriend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            tileColor: Colors.white,
            title: Text("My Posts"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14.0.r,
            ),
            onTap: this.onMyPostsTap,
            enableFeedback: true,
            enabled: true,
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text("Notifications"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14.0.r,
            ),
            onTap: this.onNotificationsTap,
            enabled: this.onNotificationsTap != null,
          ),
          ListTile(
              tileColor: Colors.white,
              title: Text("Wishlist"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: kTealColor,
                size: 14.0.r,
              ),
              onTap: this.onWishlistTap,
              enabled: this.onWishlistTap != null),
          ListTile(
            tileColor: Colors.white,
            title: Text("Invite a Friend"),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14.0.r,
            ),
            onTap: this.onInviteFriend,
            enabled: this.onInviteFriend != null,
          ),
        ],
      ).toList(),
    );
  }
}
