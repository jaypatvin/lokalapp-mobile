import 'package:flutter/material.dart';

import '../../../chat/components/chat_avatar.dart';

class UserBanner extends StatelessWidget {
  const UserBanner({
    Key? key,
    required this.displayName,
    this.profilePhoto,
    this.onTap,
  }) : super(key: key);

  final String displayName;
  final String? profilePhoto;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      leading: ChatAvatar(
        displayName: displayName,
        displayPhoto: profilePhoto,
      ),
      title: Text(
        displayName,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      trailing: const Text(
        'No reviews yet',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
