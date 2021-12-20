import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/constants/themes.dart';

class PostOptions extends StatelessWidget {
  const PostOptions({
    Key? key,
    this.onEditPost,
    this.onDeletePost,
    this.onCopyLink,
    this.onReportPost,
    this.onHidePost,
  }) : super(key: key);

  final void Function()? onEditPost;
  final void Function()? onDeletePost;
  final void Function()? onCopyLink;
  final void Function()? onReportPost;
  final void Function()? onHidePost;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (onReportPost != null)
          GestureDetector(
            onTap: onReportPost,
            child: ListTile(
              leading: Icon(
                MdiIcons.alertCircleOutline,
                color: kPinkColor,
              ),
              title: Text(
                'Report Post',
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: kPinkColor),
              ),
            ),
          ),
        if (onEditPost != null)
          GestureDetector(
            onTap: onEditPost,
            child: ListTile(
              leading: Icon(
                MdiIcons.squareEditOutline,
                color: Colors.black,
              ),
              title: Text(
                'Edit Post',
                softWrap: true,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        if (onHidePost != null)
          GestureDetector(
            onTap: onHidePost,
            child: ListTile(
              leading: Icon(
                MdiIcons.eyeOffOutline,
                color: Colors.black,
              ),
              title: Text(
                'Hide Post',
                softWrap: true,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        if (onDeletePost != null)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 2000), () {
                onDeletePost?.call();
              });
            },
            child: ListTile(
              leading: Icon(
                MdiIcons.trashCanOutline,
                color: kPinkColor,
              ),
              title: Text(
                'Delete Post',
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: kPinkColor),
              ),
            ),
          ),
        if (onCopyLink != null)
          GestureDetector(
            onTap: onCopyLink,
            child: ListTile(
              leading: Icon(
                MdiIcons.linkVariant,
                color: Colors.black,
              ),
              title: Text(
                "Copy Link",
                softWrap: true,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
      ],
    );
  }
}
