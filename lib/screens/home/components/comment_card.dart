import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_feed_comment.dart';
import '../../../models/lokal_user.dart';
import '../../../providers/auth.dart';
import '../../../providers/users.dart';
import '../../../state/mvvm_builder.widget.dart';
import '../../../state/views/hook.view.dart';
import '../../../utils/constants/themes.dart';
import '../../../utils/functions.utils.dart';
import '../../../view_models/home/comment_card.vm.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import '../../chat/components/chat_avatar.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.activityId,
    required this.comment,
  }) : super(key: key);

  final String activityId;
  final ActivityFeedComment comment;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _CommentCardView(),
      viewModel: CommentCardViewModel(
        activityId: activityId,
        comment: comment,
      ),
    );
  }
}

class _CommentCardView extends HookView<CommentCardViewModel> {
  @override
  Widget render(BuildContext context, CommentCardViewModel vm) {
    final _currentUser = context.watch<Auth>().user!;
    final user = useMemoized<LokalUser?>(
      () => context.read<Users>().findById(vm.comment.userId),
      [vm.comment],
    );

    final _isCurrentUser = useMemoized<bool>(
      () => user?.id == _currentUser.id,
      [user, _currentUser],
    );

    final _images = useMemoized<SizedBox>(
      () {
        final images = vm.comment.images;
        return SizedBox(
          height: images.isNotEmpty ? 142 : 0,
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: images.map<StaggeredGridTile>((image) {
              final index = images.indexOf(image);
              final crossAxisCellCount =
                  images.length % 2 != 0 && index == 0 ? 2 : 1;
              return StaggeredGridTile.count(
                crossAxisCellCount: crossAxisCellCount,
                mainAxisCellCount: 1,
                child: NetworkPhotoThumbnail(
                  key: Key('post_details_${images[index].url}'),
                  heroTag: 'post_details_${images[index].url}',
                  galleryItem: images[index],
                  onTap: () => openGallery(context, index, images),
                ),
              );
            }).toList(),
          ),
        );
      },
      [vm.comment, vm.activityId],
    );

    return InkWell(
      onLongPress: _isCurrentUser
          ? () => vm.onLongPress(dialog: _CommentOptions(onDelete: vm.onDelete))
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChatAvatar(
                  displayName: user?.displayName,
                  displayPhoto: user?.profilePhoto,
                  radius: 18.0,
                  onTap: vm.onUserPressed,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${user?.firstName} ${user?.lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(color: Colors.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = vm.onUserPressed,
                            ),
                            TextSpan(
                              text: ' ${vm.comment.message}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _images,
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    vm.isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
                    color: vm.isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: vm.onLike,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentOptions extends StatelessWidget {
  // TODO: add comment options
  const _CommentOptions({
    Key? key,
    // ignore: unused_element
    this.onReply,
    // ignore: unused_element
    this.onHide,
    // ignore: unused_element
    this.onReport,
    this.onDelete,
  }) : super(key: key);

  final void Function()? onReply;
  final void Function()? onHide;
  final void Function()? onReport;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (onReply != null)
          ListTile(
            onTap: onReply,
            leading: const Icon(
              MdiIcons.reply,
              color: kTealColor,
            ),
            title: Text(
              'Reply',
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: kTealColor,
                  ),
            ),
          ),
        if (onHide != null)
          ListTile(
            onTap: onHide,
            leading: const Icon(
              MdiIcons.eyeOffOutline,
              color: Colors.black,
            ),
            title: Text(
              'Hide Comment',
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        if (onReport != null)
          ListTile(
            onTap: onReport,
            leading: const Icon(
              MdiIcons.alertCircleOutline,
              color: kPinkColor,
            ),
            title: Text(
              'Report Comment',
              softWrap: true,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: kPinkColor,
                  ),
            ),
          ),
        if (onDelete != null)
          ListTile(
            onTap: onDelete,
            leading: const Icon(
              MdiIcons.trashCanOutline,
              color: kPinkColor,
            ),
            title: Text(
              'Delete Comment',
              softWrap: true,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: kPinkColor),
            ),
          ),
      ],
    );
  }
}
