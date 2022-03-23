import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../utils/constants/themes.dart';

enum MemberType { user, product, shop }

class ChatMember {
  final String? id;
  final String displayName;
  final String? displayPhoto;
  final MemberType type;

  const ChatMember({
    this.id,
    required this.displayName,
    this.displayPhoto,
    required this.type,
  });

  @override
  String toString() {
    return 'type: $type id: $id, displayName: $displayName, '
        'displayPhoto: $displayPhoto';
  }
}

class ChatAvatar extends StatelessWidget {
  final String? displayName;
  final String? displayPhoto;
  final void Function()? onTap;
  final double radius;
  const ChatAvatar({
    required this.displayName,
    this.displayPhoto = '',
    this.onTap,
    this.radius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: radius * 2,
        width: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withOpacity(0.3)),
          color: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            imageUrl: displayPhoto ?? '',
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            errorWidget: (ctx, url, err) => Center(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text(
                  displayName?[0] ?? '',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .subtitle1
                      ?.copyWith(color: kTealColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
