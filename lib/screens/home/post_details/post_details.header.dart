import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../chat/components/chat_avatar.dart';

class PostDetailsHeader extends StatelessWidget {
  const PostDetailsHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.photo,
    this.onTap,
    this.spacing = 10.0,
  }) : super(key: key);

  final String firstName;
  final String lastName;
  final String? photo;
  final void Function()? onTap;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          ChatAvatar(
            displayName: firstName,
            displayPhoto: photo,
            radius: 24.0.r,
          ),
          SizedBox(width: spacing),
          Text(
            '$firstName $lastName',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 19.0.sp),
          ),
        ],
      ),
    );
  }
}
