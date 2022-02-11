import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      child: ListTile(
        onTap: onTap,
        leading: ChatAvatar(
          displayName: displayName,
          displayPhoto: profilePhoto,
        ),
        title: Text(
          displayName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14.0.sp,
          ),
        ),
        trailing: const Text(
          'No reviews yet',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
