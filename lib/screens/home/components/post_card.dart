import 'package:flutter/material.dart';
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

    final user = vm.context.read<Users>().findById(activity.userId);

    return ListTile(
      // onTap: () => vm.onUserPressed(activity),
      leading: ChatAvatar(
        displayName: user?.displayName,
        displayPhoto: user?.profilePhoto,
        radius: 20.0,
      ),
      title: Row(
        children: [
          Text(
            '${user?.firstName} ${user?.lastName}',
            style: Theme.of(vm.context)
                .textTheme
                .subtitle2
                ?.copyWith(color: Colors.black),
          ),
          Text(
            createdSince,
            style: Theme.of(vm.context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
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
  }) {
    return SizedBox(
      height: activity.message.isEmpty ? 0 : null,
      child: GestureDetector(
        onTap: () => vm.goToPostDetails(activity),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Text(
            activity.message,
            style: Theme.of(vm.context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.black),
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ),
    );
  }

  Widget _buildPostImages(PostCardViewModel vm) {
    final images = activity.images;
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 7,
      crossAxisSpacing: 8,
      children: images.map<StaggeredGridTile>((image) {
        final index = images.indexOf(image);
        final crossAxisCellCount = images.length % 2 != 0 && index == 0 ? 2 : 1;
        return StaggeredGridTile.count(
          crossAxisCellCount: crossAxisCellCount,
          mainAxisCellCount: 1,
          child: NetworkPhotoThumbnail(
            key: Key('post_card_${images[index].url}'),
            heroTag: 'post_card_${images[index].url}',
            galleryItem: images[index],
            onTap: () => vm.openGallery(activity, index),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget render(BuildContext context, PostCardViewModel vm) {
    return GestureDetector(
      onTap: () => vm.goToPostDetails(activity),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            _buildHeader(vm),
            const SizedBox(height: 25),
            _buildMessageBody(vm: vm),
            if (activity.message.isNotEmpty) const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: _buildPostImages(vm),
            ),
            if (activity.images.isNotEmpty) const SizedBox(height: 20),
            const Divider(color: Colors.grey, indent: 21, endIndent: 21),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(
                      minHeight: kMinInteractiveDimension,
                    ),
                    onPressed: () => vm.onLike(activity),
                    padding: const EdgeInsets.only(right: 10),
                    iconSize: 20,
                    icon: Icon(
                      activity.liked ? MdiIcons.heart : MdiIcons.heartOutline,
                      color: activity.liked ? Colors.red : Colors.black,
                    ),
                  ),
                  Text(
                    activity.likedCount.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontSize: 15.0),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        constraints: const BoxConstraints(
                          minHeight: kMinInteractiveDimension,
                        ),
                        onPressed: () => vm.goToPostDetails(activity),
                        padding: const EdgeInsets.only(right: 10),
                        iconSize: 20,
                        icon: const Icon(MdiIcons.commentOutline),
                      ),
                      Text(
                        activity.commentCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(fontSize: 15.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
