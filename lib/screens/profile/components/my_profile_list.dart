import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/themes.dart';

class MyProfileList extends StatelessWidget {
  final void Function() onMyPostsTap;
  final void Function()? onWishlistTap;
  final void Function()? onInviteFriend;
  const MyProfileList({
    Key? key,
    required this.onMyPostsTap,
    required this.onWishlistTap,
    required this.onInviteFriend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            tileColor: Colors.white,
            title: const Text('My Posts'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14.0.r,
            ),
            onTap: onMyPostsTap,
            enableFeedback: true,
          ),
          ListTile(
            tileColor: Colors.white,
            title: const Text('Wishlist'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14.0.r,
            ),
            onTap: onWishlistTap,
            enabled: onWishlistTap != null,
          ),
          ListTile(
            tileColor: Colors.white,
            title: const Text('Invite a Friend'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14.0.r,
            ),
            onTap: onInviteFriend,
            enabled: onInviteFriend != null,
          ),
        ],
      ).toList(),
    );
  }
}
