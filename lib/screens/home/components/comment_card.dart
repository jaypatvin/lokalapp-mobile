import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_feed_comment.dart';
import '../../../providers/users.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/functions.utils.dart';
import '../../../view_models/home/comment_card.vm.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import '../../chat/components/chat_avatar.dart';

class CommentCard extends StatelessWidget {
  final String activityId;
  final ActivityFeedComment comment;

  const CommentCard({
    Key? key,
    required this.activityId,
    required this.comment,
  }) : super(key: key);

  Widget _buildImages() {
    final images = comment.images;
    return Container(
      height: images.length > 0 ? 95.h : 0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            height: 95.h,
            width: 95.h,
            child: NetworkPhotoThumbnail(
              galleryItem: images[index],
              onTap: () => openGallery(context, index, images),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<Users>().findById(comment.userId);
    return ChangeNotifierProvider(
      create: (ctx) => CommentCardViewModel(
        context: context,
        activityId: activityId,
        comment: comment,
      )..init(),
      builder: (_, __) {
        return Consumer<CommentCardViewModel>(
          builder: (ctx, vm, _) {
            return InkWell(
              onLongPress: () => vm.onLongPress(_CommentOptions()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ChatAvatar(
                      displayName: user.displayName,
                      displayPhoto: user.profilePhoto,
                      radius: 18.0.r,
                      onTap: vm.onUserPressed,
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${user.firstName} ${user.lastName}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Colors.black),
                            recognizer: TapGestureRecognizer()
                              ..onTap = vm.onUserPressed,
                          ),
                          TextSpan(
                            text: " ${comment.message}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.black ),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        vm.isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
                        color: vm.isLiked ? Colors.red : Colors.black,
                      ),
                      onPressed: vm.onLike,
                    ),
                  ),
                  _buildImages(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CommentOptions extends StatelessWidget {
  const _CommentOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          onTap: () {},
          leading: Icon(
            MdiIcons.reply,
            color: kTealColor,
          ),
          title: Text(
            "Reply",
            softWrap: true,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: kTealColor,
                ),
          ),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(
            MdiIcons.eyeOffOutline,
            color: Colors.black,
          ),
          title: Text(
            "Hide Comment",
            softWrap: true,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(
            MdiIcons.alertCircleOutline,
            color: kPinkColor,
          ),
          title: Text(
            "Report Comment",
            softWrap: true,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: kPinkColor,
                ),
          ),
        ),
      ],
    );
  }
}
