import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/activity_feed.dart';

class CommentAndLikeRow extends StatelessWidget {
  const CommentAndLikeRow({
    Key? key,
    required this.activity,
    required this.onLike,
  }) : super(key: key);

  final ActivityFeed activity;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffE0E0E0),
        ),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onLike,
            icon: Icon(
              activity.liked ? MdiIcons.heart : MdiIcons.heartOutline,
              color: activity.liked ? Colors.red : Colors.black,
              size: 20,
            ),
            label: Text(
              activity.likedCount.toString(),
              style:
                  Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 15),
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              MdiIcons.commentOutline,
              color: Colors.black,
              size: 20,
            ),
            label: Text(
              activity.commentCount.toString(),
              style:
                  Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
