import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_feed.dart';
import '../../../providers/users.dart';
import '../../../view_models/home/post_card.vm.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import '../../chat/components/chat_avatar.dart';

class PostCard extends StatelessWidget {
  const PostCard({required this.activity});

  final ActivityFeed activity;

  Widget _buildHeader(PostCardViewModel vm) {
    final difference = DateTime.now().difference(this.activity.createdAt);
    String createdSince = " • ";
    if (difference.inDays >= 1) {
      createdSince += "${difference.inDays}d";
    } else if (difference.inHours >= 1) {
      createdSince += "${difference.inHours}h";
    } else if (difference.inMinutes >= 1) {
      createdSince += "${difference.inMinutes}m";
    } else {
      createdSince += "${difference.inSeconds}s";
    }

    final user = vm.context.read<Users>().findById(this.activity.userId);

    return ListTile(
      onTap: () => vm.onUserPressed(activity),
      leading: ChatAvatar(
        displayName: user.displayName,
        displayPhoto: user.profilePhoto,
        radius: 24.0.r,
      ),
      title: Row(
        children: [
          Text(
            "${user.firstName} ${user.lastName}",
            style: Theme.of(vm.context).textTheme.subtitle2,
          ),
          Text(
            createdSince,
            style: Theme.of(vm.context).textTheme.subtitle2,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
      trailing: vm.isCurrentUser(activity)
          ? IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () => vm.onPostOptionsPressed(
                _PostOptions(
                  isUser: vm.isCurrentUser(activity),
                  onDeletePost: () => vm.onDeletePost(activity),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMessageBody({
    required PostCardViewModel vm,
    double horizontalPadding = 8.0,
  }) {
    return GestureDetector(
      onTap: () => vm.goToPostDetails(activity),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(
          this.activity.message,
          style: TextStyle(
            fontFamily: "Goldplay",
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }

  Widget _buildPostImages(PostCardViewModel vm) {
    final images = this.activity.images;
    final count = images.length;
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: count,
      crossAxisCount: 2,
      itemBuilder: (ctx, index) {
        return NetworkPhotoThumbnail(
          galleryItem: images[index],
          onTap: () => vm.openGallery(activity, index),
        );
      },
      staggeredTileBuilder: (index) {
        if (count % 2 != 0 && index == 0) {
          return new StaggeredTile.count(2, 1);
        }
        return new StaggeredTile.count(1, 1);
      },
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<PostCardViewModel>(
      create: (ctx) => PostCardViewModel(
        ctx,
      )..init(),
      builder: (_, __) {
        return Consumer<PostCardViewModel>(
          builder: (ctx, vm, _) {
            final height = MediaQuery.of(context).size.height;
            final width = MediaQuery.of(context).size.width;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: GestureDetector(
                onTap: () => vm.goToPostDetails(activity),
                child: Card(
                  margin: EdgeInsets.only(top: height * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10.0.h),
                      _buildHeader(vm),
                      SizedBox(height: 5.0.h),
                      _buildMessageBody(
                        vm: vm,
                        horizontalPadding: 20.0.w,
                      ),
                      SizedBox(height: 5.0.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0.w,
                        ),
                        child: _buildPostImages(vm),
                      ),
                      Divider(
                        color: Colors.grey,
                        indent: 20.0.w,
                        endIndent: 20.0.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 20.0.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                this.activity.liked
                                    ? MdiIcons.heart
                                    : MdiIcons.heartOutline,
                                color: this.activity.liked
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              onPressed: () => vm.onLike(activity),
                            ),
                            Text(
                              this.activity.likedCount.toString(),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(MdiIcons.commentOutline),
                                  onPressed: () => vm.goToPostDetails(activity),
                                ),
                                Text(
                                  this.activity.commentCount.toString(),
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PostOptions extends StatelessWidget {
  const _PostOptions({
    Key? key,
    this.isUser = false,
    this.onEditPost,
    this.onDeletePost,
  }) : super(key: key);

  final bool isUser;
  final void Function()? onEditPost;
  final void Function()? onDeletePost;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // GestureDetector(
        //   onTap: () {
        //     if (this.onEditPost == null) return;
        //     this.onEditPost!();
        //     Navigator.pop(context);
        //   },
        //   child: ListTile(
        //     leading: Icon(
        //       MdiIcons.alertCircleOutline,
        //       color: kPinkColor,
        //     ),
        //     title: Text(
        //       isUser ? "Edit Post" : "Report Post",
        //       softWrap: true,
        //       style: Theme.of(context)
        //           .textTheme
        //           .subtitle1!
        //           .copyWith(color: kPinkColor),
        //     ),
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            if (this.onDeletePost == null) return;
            this.onDeletePost!();
            Navigator.pop(context);
          },
          child: ListTile(
            leading: Icon(
              MdiIcons.eyeOffOutline,
              color: Colors.black,
            ),
            title: Text(
              isUser ? "Delete Post" : "Hide Post",
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {},
        //   child: ListTile(
        //     leading: Icon(
        //       MdiIcons.linkVariant,
        //       color: Colors.black,
        //     ),
        //     title: Text(
        //       "Copy Link",
        //       softWrap: true,
        //       style: Theme.of(context).textTheme.subtitle1,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
