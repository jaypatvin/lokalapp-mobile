import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/shop.dart';
import '../../../utils/constants/themes.dart';
import '../../chat/components/chat_avatar.dart';

class ShopTile extends StatelessWidget {
  final Shop shop;

  final void Function() onGoToShop;
  const ShopTile({
    Key? key,
    required this.shop,
    required this.onGoToShop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10.0.h),
      tileColor: Colors.white,
      leading: ChatAvatar(
        displayName: shop.name,
        displayPhoto: shop.profilePhoto,
      ),
      onTap: onGoToShop,
      title: Text(
        shop.name,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14.0.sp,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.star, color: Colors.amber, size: 20),
          SizedBox(
            width: 3,
          ),
          // TODO: ask for shop rating ????
          Text(
            '0',
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
