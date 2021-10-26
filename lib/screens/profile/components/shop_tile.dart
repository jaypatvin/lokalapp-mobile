import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../models/user_shop.dart';
import '../../../utils/constants/themes.dart';
import '../../chat/components/chat_avatar.dart';
import '../user_shop.dart';

class ShopTile extends StatelessWidget {
  final ShopModel shop;
  const ShopTile({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ChatAvatar(
        displayName: shop.name,
        displayPhoto: shop.profilePhoto,
      ),
      onTap: () {
        pushNewScreenWithRouteSettings(
          context,
          screen: UserShop(),
          settings: RouteSettings(name: UserShop.routeName),
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      title: Text(
        shop.name!,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14.0.sp,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 20),
          SizedBox(
            width: 3,
          ),
          Text(
            "0",
            style: TextStyle(color: Colors.amber, fontSize: 14),
          ),
          SizedBox(
            width: 15,
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: kTealColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}
