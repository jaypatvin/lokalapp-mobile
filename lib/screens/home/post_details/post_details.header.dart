import 'package:flutter/material.dart';

import '../../chat/components/chat_avatar.dart';

class PostDetailsHeader extends StatelessWidget {
  const PostDetailsHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    this.photo,
    this.onTap,
    this.spacing = 15.0,
  });

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
            radius: 30,
          ),
          SizedBox(width: spacing),
          Text(
            '$firstName $lastName',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
