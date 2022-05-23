import 'package:flutter/material.dart';

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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      tileColor: Colors.white,
      leading: ChatAvatar(
        displayName: shop.name,
        displayPhoto: shop.profilePhoto,
      ),
      onTap: onGoToShop,
      title: Text(
        shop.name,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 20),
          const SizedBox(width: 3),
          // TODO: ask for shop rating ????
          Text(
            0.0.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: kTealColor,
            size: 16,
          ),
        ],
      ),
    );
  }
}
