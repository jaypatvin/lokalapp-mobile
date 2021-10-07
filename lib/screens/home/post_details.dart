import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/lokal_images.dart';
import '../../providers/activities.dart';
import '../../providers/user.dart';
import '../../providers/users.dart';
import '../../services/local_image_service.dart';
import '../../utils/functions.utils.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/input_images.dart';
import '../../widgets/input_text_field.dart';
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import '../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';
import 'components/comment_card.dart';

class PostDetails extends StatefulWidget {
  final ActivityFeed activity;
  final Function(String) onUserPressed;
  final Function() onLike;

  PostDetails({
    @required this.activity,
    @required this.onUserPressed,
    @required this.onLike,
  });

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final TextEditingController commentInputController = TextEditingController();
  final FocusNode _commentInputFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool showImagePicker = false;
  CustomPickerDataProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CustomPickerDataProvider>(context, listen: false);
    provider.onPickMax.addListener(showMaxAssetsText);
    provider.pickedNotifier.addListener(onPick);
    providerInit();
  }

  @override
  void dispose() {
    provider.picked.clear();
    provider.removeListener(showMaxAssetsText);
    provider.pickedNotifier.removeListener(onPick);
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
    provider.resetPathList(pathList);
  }

  void showMaxAssetsText() {
    // TODO: maybe use OKToast plugin
    final snackBar = SnackBar(
      content: Text("You have reached the limit of 5 media per post."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget buildHeader({
    @required String firstName,
    @required String lastName,
    String photo,
    double spacing,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
          radius: 24.0.r,
        ),
        SizedBox(width: spacing),
        Text(
          "$firstName $lastName",
          style: kTextStyle.copyWith(fontSize: 19.0.sp),
        ),
      ],
    );
  }

  Widget buildLikeAndCommentRow() {
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
              widget.activity.liked ? MdiIcons.heart : MdiIcons.heartOutline,
              color: widget.activity.liked ? Colors.red : Colors.black,
            ),
            onPressed: () {
              this.widget.onLike();
              setState(() {});
            },
          ),
          SizedBox(width: 8.0.w),
          Text(this.widget.activity.likedCount.toString(), style: kTextStyle),
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
          Text(this.widget.activity.commentCount.toString(), style: kTextStyle),
        ],
      ),
    );
  }

  void onCommentLongPress() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  MdiIcons.reply,
                  color: kTealColor,
                ),
                title: Text(
                  "Reply",
                  softWrap: true,
                  style: kTextStyle.copyWith(color: kTealColor),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  MdiIcons.eyeOffOutline,
                  color: Colors.black,
                ),
                title: Text(
                  "Hide Comment",
                  softWrap: true,
                  style: kTextStyle,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  MdiIcons.alertCircleOutline,
                  color: kPinkColor,
                ),
                title: Text(
                  "Report Comment",
                  softWrap: true,
                  style: kTextStyle.copyWith(color: kPinkColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPostImages() {
    final images = this.widget.activity.images;
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
      provider.picked.removeAt(index);
    });
  }

  Future<void> createComment() async {
    final cUser = context.read<CurrentUser>();
    final service = context.read<LocalImageService>();
    final gallery = <LokalImages>[];
    for (var asset in provider.picked) {
      var file = await asset.file;
      var url = await service.uploadImage(file: file, name: 'post_photo');
      gallery.add(LokalImages(url: url, order: provider.picked.indexOf(asset)));
    }

    Map<String, dynamic> body = {
      "user_id": cUser.id,
      "message": commentInputController.text,
      "images": gallery.map((x) => x.toMap()).toList(),
    };

    final success = await context.read<Activities>().createComment(
          activityId: widget.activity.id,
          body: body,
        );

    if (success) {
      commentInputController.clear();
      setState(() {
        provider.picked.clear();
      });
      Provider.of<Activities>(context, listen: false).fetchComments(
        activityId: widget.activity.id,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cannot create a comment"),
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
                    height: provider.picked.length > 0 ? 100 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: InputImages(
                      pickedImages: provider.picked,
                      onImageRemove: (index) => setState(
                        () => provider.picked.removeAt(index),
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

  Widget _buildComments() {
    final cUser = context.read<CurrentUser>();
    return Consumer<Activities>(
      builder: (_, activities, __) {
        return activities.isCommentLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.activity.comments?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final comment = widget.activity.comments[index];
                  final commentUser =
                      context.read<Users>().findById(comment.userId);
                  return Column(
                    children: [
                      CommentCard(
                        user: commentUser,
                        message: comment.message,
                        images: comment.images ?? [],
                        onLongPress: this.onCommentLongPress,
                        onUserPressed: widget.onUserPressed,
                        onLike: () {
                          if (comment.liked) {
                            Provider.of<Activities>(context, listen: false)
                                .unlikeComment(
                              commentId: comment.id,
                              activityId: widget.activity.id,
                              userId: cUser.id,
                            );
                            debugPrint("Unliked comment ${comment.id}");
                          } else {
                            Provider.of<Activities>(context, listen: false)
                                .likeComment(
                              commentId: comment.id,
                              activityId: widget.activity.id,
                              userId: cUser.id,
                            );
                            debugPrint("Liked comment ${comment.id}");
                          }
                        },
                        liked: comment.liked,
                      ),
                      Divider(),
                    ],
                  );
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<Users>().findById(widget.activity.userId);
    final activities = context.read<Activities>();
    return Scaffold(
      backgroundColor: Colors.white,
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
        onRefresh: () => activities.fetchComments(
          activityId: widget.activity.id,
        ),
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
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
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
                              padding: EdgeInsets.symmetric(vertical: 20.0.h),
                              child: buildHeader(
                                firstName: user.firstName,
                                lastName: user.lastName,
                                photo: user.profilePhoto,
                                spacing: 10.0.w,
                              ),
                            ),
                            Text(
                              widget.activity.message,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20.0.h),
                            buildPostImages(),
                            SizedBox(height: 15.0.h),
                            Text(
                              DateFormat("hh:mm a • dd MMMM yyyy")
                                  .format(widget.activity.createdAt),
                              style: kTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      buildLikeAndCommentRow(),
                      SizedBox(height: 10.0.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                        child: _buildComments(),
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
                height: this.showImagePicker ? 150.0.h : 0.0.h,
                child: ImageGalleryPicker(
                  provider,
                  pickerHeight: 150.h,
                  assetHeight: 150.h,
                  assetWidth: 150.h,
                  thumbSize: 200,
                  enableSpecialItemBuilder: true,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: MediaQuery.of(context).viewInsets.bottom > 0
                    ? kKeyboardActionHeight
                    : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
