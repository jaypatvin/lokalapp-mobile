import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/activity_feed_comment.dart';
import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../providers/users.dart';
import '../../services/database.dart';
import '../../services/local_image_service.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../utils/functions.utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/inputs/input_images_picker.dart';
import '../../widgets/inputs/input_text_field.dart';
import '../../widgets/keyboard_visibility_builder.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import 'components/comment_card.dart';

class PostDetails extends StatefulWidget {
  static const routeName = '/home/post_details';
  const PostDetails({
    //required this.activity,
    required this.activityId,
    required this.onUserPressed,
    required this.onLike,
  });

  //final ActivityFeed activity;
  final String activityId;
  final void Function(String) onUserPressed;
  final void Function() onLike;

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final TextEditingController commentInputController = TextEditingController();
  final FocusNode _commentInputFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool commentUploading = false;
  bool showImagePicker = false;
  CustomPickerDataProvider? provider;

  late Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = Database.instance.getCommentFeed(widget.activityId);
    provider = Provider.of<CustomPickerDataProvider>(context, listen: false);
    provider!.onPickMax.addListener(showMaxAssetsText);
    provider!.pickedNotifier.addListener(onPick);
    providerInit();
  }

  @override
  void dispose() {
    provider!.picked.clear();
    provider!.removeListener(showMaxAssetsText);
    provider!.pickedNotifier.removeListener(onPick);
    super.dispose();
  }

  void onPick() {
    setState(() {
      Timer(Duration(milliseconds: 300), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      });
    });
  }

  Future<void> providerInit() async {
    final pathList = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    provider!.resetPathList(pathList);
  }

  void showMaxAssetsText() {
    // TODO: maybe use OKToast plugin
    final snackBar = SnackBar(
      content: Text("You have reached the limit of 5 media per post."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildHeader({
    required String? firstName,
    required String? lastName,
    required String photo,
    void Function()? onTap,
    double? spacing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
            radius: 24.0.r,
          ),
          SizedBox(width: spacing),
          Text(
            "$firstName $lastName",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 19.0.sp,
                ),
          ),
        ],
      ),
    );
  }

  Widget buildLikeAndCommentRow(ActivityFeed activity) {
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
            onPressed: () {
              this.widget.onLike();
              setState(() {});
            },
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
            onPressed: () {
              //TODO: set focus on comment ?
              // should we do something about it ?
            },
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

  Widget buildPostImages(ActivityFeed activity) {
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

  void removeAsset(int index) {
    setState(() {
      provider!.picked.removeAt(index);
    });
  }

  Future<void> createComment() async {
    if (commentUploading || commentInputController.text.isEmpty) return;

    commentUploading = true;
    final cUser = context.read<Auth>().user!;
    final service = context.read<LocalImageService>();
    final gallery = <LokalImages>[];
    for (var asset in provider!.picked) {
      var file = await asset.file;
      var url = await service.uploadImage(file: file!, name: 'post_photo');
      gallery
          .add(LokalImages(url: url, order: provider!.picked.indexOf(asset)));
    }

    Map<String, dynamic> body = {
      "user_id": cUser.id,
      "message": commentInputController.text,
      "images": gallery.map((x) => x.toMap()).toList(),
    };

    try {
      await context.read<Activities>().createComment(
            activityId: widget.activityId,
            body: body,
          );

      commentUploading = false;
      commentInputController.clear();
      setState(() {
        provider!.picked.clear();
      });
    } catch (e) {
      commentUploading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot create a comment: $e'),
        ),
      );
    }
  }

  Widget buildCommentInput() {
    return Row(
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
            setState(() {
              this.showImagePicker = !this.showImagePicker;
              Timer(Duration(milliseconds: 300), () {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                );
              });
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
                    height: provider!.picked.length > 0 ? 100 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: InputImagesPicker(
                      pickedImages: provider!.picked,
                      onImageRemove: (index) => setState(
                        () => provider!.picked.removeAt(index),
                      ),
                    ),
                  ),
                  InputTextField(
                    inputController: commentInputController,
                    inputFocusNode: _commentInputFocusNode,
                    onSend: createComment,
                    onTap: () => showImagePicker = false,
                    hintText: "Add a comment...",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    return Consumer<Activities>(
      builder: (ctx, activities, _) {
        final activity = activities.findById(widget.activityId);
        final user = context.read<Users>().findById(activity.userId)!;
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            backgroundColor: kTealColor,
            titleText: "${user.firstName}'s Post",
            titleStyle: TextStyle(color: Colors.white),
            onPressedLeading: () => Navigator.pop(context),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 30.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: KeyboardActions(
              disableScroll: true,
              tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
              config: KeyboardActionsConfig(
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
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        );
                      },
                    ],
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
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
                                  padding:
                                      EdgeInsets.symmetric(vertical: 20.0.h),
                                  child: buildHeader(
                                    onTap: () => widget.onUserPressed(user.id!),
                                    firstName: user.firstName,
                                    lastName: user.lastName,
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
                                buildPostImages(activity),
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
                          buildLikeAndCommentRow(activity),
                          SizedBox(height: 10.0.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                            child: _CommentFeed(
                              _stream,
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
                    child: buildCommentInput(),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: this.showImagePicker ? 150.0.h : 0,
                    child: ImageGalleryPicker(
                      provider,
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
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
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
          ),
        );
      },
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
              final docs = snapshot.data!.docs;
              final comments = <ActivityFeedComment>[];
              for (final doc in docs) {
                final comment = ActivityFeedComment.fromDocument(doc);
                if (comment.archived) continue;

                comments.add(comment);
              }

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final comment = ActivityFeedComment.fromDocument(
                      snapshot.data!.docs[index]);
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
