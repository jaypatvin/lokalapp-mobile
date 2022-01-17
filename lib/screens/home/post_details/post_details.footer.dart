import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/activity_feed.dart';

class CommentAndLikeRow extends StatelessWidget {
  const CommentAndLikeRow({
    Key? key,
    required this.activity,
    required this.onLike,
  }) : super(key: key);

  final ActivityFeed activity;
  final void Function() onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffE0E0E0),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: Icon(
              activity.liked ? MdiIcons.heart : MdiIcons.heartOutline,
              color: activity.liked ? Colors.red : Colors.black,
            ),
            onPressed: onLike,
          ),
          SizedBox(width: 8.0.w),
          Text(
            activity.likedCount.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const Spacer(),
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: const Icon(MdiIcons.commentOutline),
            onPressed: () {},
          ),
          SizedBox(width: 8.0.w),
          Text(
            activity.commentCount.toString(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
