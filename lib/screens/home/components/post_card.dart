import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_feed.dart';
import '../../../providers/users.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/stateless.view.dart';
import '../../../view_models/home/post_card.vm.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import '../../chat/components/chat_avatar.dart';
import 'post_options.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key, required this.activity}) : super(key: key);
  final ActivityFeed activity;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _PostCardView(activity),
      viewModel: PostCardViewModel(),
    );
  }
}

class _PostCardView extends StatelessView<PostCardViewModel> {
  const _PostCardView(
    this.activity, {
    Key? key,
    bool reactive = true,
  }) : super(key: key, reactive: reactive);
  final ActivityFeed activity;

  Widget _buildHeader(PostCardViewModel vm) {
    final difference = DateTime.now().difference(activity.createdAt);
    String createdSince = ' • ';
    if (difference.inDays >= 1) {
      createdSince += '${difference.inDays}d';
    } else if (difference.inHours >= 1) {
      createdSince += '${difference.inHours}h';
    } else if (difference.inMinutes >= 1) {
      createdSince += '${difference.inMinutes}m';
    } else {
      createdSince += '${difference.inSeconds}s';
    }

    final user = vm.context.read<Users>().findById(activity.userId)!;

    return ListTile(
      // onTap: () => vm.onUserPressed(activity),
      leading: ChatAvatar(
        displayName: user.displayName,
        displayPhoto: user.profilePhoto,
        radius: 24.0.r,
      ),
      title: Row(
        children: [
          Text(
            '${user.firstName} ${user.lastName}',
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
              icon: const Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () => vm.onPostOptionsPressed(
                PostOptions(
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
          activity.message,
          style: TextStyle(
            fontFamily: 'Goldplay',
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
    final images = activity.images;
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0.w,
      crossAxisSpacing: 4.0.h,
      children: images.map<StaggeredGridTile>((image) {
        final index = images.indexOf(image);
        final crossAxisCellCount = images.length % 2 != 0 && index == 0 ? 2 : 1;
        return StaggeredGridTile.count(
          crossAxisCellCount: crossAxisCellCount,
          mainAxisCellCount: 1,
          child: NetworkPhotoThumbnail(
            key: Key('post_details_${images[index].url}'),
            galleryItem: images[index],
            onTap: () => vm.openGallery(activity, index),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget render(BuildContext context, PostCardViewModel vm) {
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
                  children: [
                    IconButton(
                      icon: Icon(
                        activity.liked ? MdiIcons.heart : MdiIcons.heartOutline,
                        color: activity.liked ? Colors.red : Colors.black,
                      ),
                      onPressed: () => vm.onLike(activity),
                    ),
                    Text(
                      activity.likedCount.toString(),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(MdiIcons.commentOutline),
                          onPressed: () => vm.goToPostDetails(activity),
                        ),
                        Text(
                          activity.commentCount.toString(),
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
  }
}
