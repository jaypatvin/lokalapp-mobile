import 'package:flutter/material.dart';

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
            title: const Text(
              'My Posts',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14,
            ),
            onTap: onMyPostsTap,
            enableFeedback: true,
          ),
          ListTile(
            tileColor: Colors.white,
            title: const Text(
              'Wishlist',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14,
            ),
            onTap: onWishlistTap,
            enabled: onWishlistTap != null,
          ),
          ListTile(
            tileColor: Colors.white,
            title: const Text(
              'Invite a Friend',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: kTealColor,
              size: 14,
            ),
            onTap: onInviteFriend,
            enabled: onInviteFriend != null,
          ),
        ],
      ).toList(),
    );
  }
}
