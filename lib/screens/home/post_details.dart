import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/activity_feed_comment.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../state/mvvm_builder.widget.dart';
import '../../state/views/hook.view.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../utils/functions.utils.dart';
import '../../view_models/home/post_details.vm.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/input_images_picker.dart';
import '../../widgets/inputs/input_text_field.dart';
import '../../widgets/keyboard_visibility_builder.dart';
import '../../widgets/overlays/screen_loader.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import 'components/comment_card.dart';
import 'components/post_options.dart';

class PostDetails extends StatelessWidget {
  static const routeName = '/home/post_details';
  const PostDetails({
    Key? key,
    required this.activityId,
    required this.onUserPressed,
    required this.onLike,
  }) : super(key: key);

  final String activityId;
  final void Function(String) onUserPressed;
  final void Function() onLike;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: (_, __) => _PostDetailsView(),
      viewModel: PostDetailViewModel(
        activityId: activityId,
        onUserPressed: onUserPressed,
        onLike: onLike,
      ),
    );
  }
}

class _PostDetailsView extends HookView<PostDetailViewModel>
    with HookScreenLoader {
  @override
  Widget screen(BuildContext context, PostDetailViewModel vm) {
    final _scrollController = useScrollController();
    final _commentInputFocusNode = useFocusNode();
    final _showImagePicker = useState<bool>(false);

    useEffect(() {
      final listener = () {
        Timer(Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        });
      };
      vm.imageProvider.addListener(listener);
      return () => vm.imageProvider.removeListener(listener);
    }, [vm.imageProvider]);

    final _kbConfig = useMemoized<KeyboardActionsConfig>(() {
      return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey.shade200,
        nextFocus: false,
        actions: [
          KeyboardActionsItem(
            focusNode: _commentInputFocusNode,
            toolbarButtons: [
              (node) {
                return TextButton(
                  onPressed: () => node.unfocus(),
                  child: Text(
                    "Done",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                );
              },
            ],
          ),
        ],
      );
    });

    return Consumer<Activities>(
      builder: (ctx, activities, _) {
        final activity = activities.findById(vm.activityId);
        final user = context.read<Users>().findById(activity.userId)!;
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            backgroundColor: kTealColor,
            titleText: "${user.firstName}'s Post",
            titleStyle: TextStyle(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 30.sp,
                ),
                onPressed: context.read<Auth>().user!.id == activity.userId
                    ? () => vm.onPostOptionsPressed(
                          PostOptions(
                            onDeletePost: () async =>
                                await performFuture<void>(vm.onDelete),
                            onEditPost: null,
                            onCopyLink: null,
                          ),
                        )
                    : null,
              ),
            ],
          ),
          body: KeyboardActions(
            disableScroll: true,
            tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
            config: _kbConfig,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 20.0.h,
                                ),
                                child: _PostDetailsHeader(
                                  onTap: () => vm.onUserPressed(user.id!),
                                  firstName: user.firstName!,
                                  lastName: user.lastName!,
                                  photo: user.profilePhoto!,
                                  spacing: 10.0.w,
                                ),
                              ),
                              Text(
                                activity.message,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 20.0.h),
                              _PostDetailsImages(activity),
                              SizedBox(height: 15.0.h),
                              Text(
                                DateFormat("hh:mm a • dd MMMM yyyy")
                                    .format(activity.createdAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0.sp,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        _CommentAndLikeRow(
                          activity: activity,
                          onLike: vm.onLike,
                        ),
                        SizedBox(height: 10.0.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                          child: _CommentFeed(
                            vm.commentFeed,
                            activity.id,
                          ), //_buildComments(),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: kInviteScreenColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0.w,
                    vertical: 10.0.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: kTealColor),
                          ),
                          child: Icon(
                            MdiIcons.fileImageOutline,
                            color: kTealColor,
                          ),
                        ),
                        onTap: () {
                          _showImagePicker.value = !_showImagePicker.value;
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.ease,
                            );
                          });
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            border: Border.all(color: kTealColor),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  height: vm.imageProvider.picked.length > 0
                                      ? 100
                                      : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: InputImagesPicker(
                                    pickedImages: vm.imageProvider.picked,
                                    onImageRemove: vm.onImageRemove,
                                  ),
                                ),
                                InputTextField(
                                  inputController: vm.inputController,
                                  inputFocusNode: _commentInputFocusNode,
                                  onSend: vm.createComment,
                                  onTap: () => _showImagePicker.value = false,
                                  hintText: "Add a comment...",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: _showImagePicker.value ? 150.0.h : 0,
                  child: ImageGalleryPicker(
                    vm.imageProvider,
                    pickerHeight: 150.h,
                    assetHeight: 150.h,
                    assetWidth: 150.h,
                    thumbSize: 200,
                    enableSpecialItemBuilder: true,
                  ),
                ),
                KeyboardVisibilityBuilder(
                  builder: (_, __, isVisible) {
                    if (isVisible) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      });
                    }
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: isVisible ? kKeyboardActionHeight : 0,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PostDetailsHeader extends StatelessWidget {
  const _PostDetailsHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    this.photo,
    this.onTap,
    this.spacing = 10.0,
  }) : super(key: key);

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
          CircleAvatar(
            backgroundImage:
                photo?.isNotEmpty ?? false ? NetworkImage(photo!) : null,
            radius: 24.0.r,
          ),
          SizedBox(width: spacing),
          Text(
            "$firstName $lastName",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontSize: 19.0.sp),
          ),
        ],
      ),
    );
  }
}

class _PostDetailsImages extends StatelessWidget {
  const _PostDetailsImages(
    this.activity, {
    Key? key,
  }) : super(key: key);

  final ActivityFeed activity;

  @override
  Widget build(BuildContext context) {
    final images = activity.images;
    final count = images.length;
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: count,
      crossAxisCount: 2,
      itemBuilder: (ctx, index) {
        return NetworkPhotoThumbnail(
          galleryItem: images[index],
          onTap: () => openGallery(context, index, images),
        );
      },
      staggeredTileBuilder: (index) {
        if (count % 2 != 0 && index == 0) {
          return new StaggeredTile.count(2, 1);
        }
        return new StaggeredTile.count(1, 1);
      },
      mainAxisSpacing: 4.0.w,
      crossAxisSpacing: 4.0.h,
    );
  }
}

class _CommentAndLikeRow extends StatelessWidget {
  const _CommentAndLikeRow({
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
          color: Color(0xffE0E0E0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            constraints: BoxConstraints(),
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
          Spacer(),
          IconButton(
            constraints: BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: Icon(MdiIcons.commentOutline),
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

class _CommentFeed extends StatelessWidget {
  const _CommentFeed(this._stream, this._activityId, {Key? key})
      : super(key: key);

  final String _activityId;
  final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (
        ctx,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Lottie.asset(kAnimationLoading),
              ),
            );
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else if (!snapshot.hasData || snapshot.data!.docs.length == 0)
              return Text(
                'No posts yet! Be the first one to post.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              );
            else {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final comment = ActivityFeedComment.fromDocument(
                    snapshot.data!.docs[index],
                  );
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommentCard(
                        activityId: this._activityId,
                        comment: comment,
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            }
        }
      },
    );
  }
}
