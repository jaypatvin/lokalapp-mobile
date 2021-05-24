import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' show DateFormat;
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
import '../../widgets/photo_picker_gallery/image_gallery_picker.dart';
import '../../widgets/photo_picker_gallery/provider/custom_photo_provider.dart';
import '../../widgets/photo_view_gallery/thumbnails/asset_photo_thumbnail.dart';
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
          radius: 30.0,
        ),
        SizedBox(width: spacing),
        Text(
          "$firstName $lastName",
          style: kTextStyle.copyWith(fontSize: 24.0),
        ),
      ],
    );
  }

  Widget buildLikeAndCommentRow({double spacing}) {
    return Container(
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
            icon: Icon(MdiIcons.heartOutline),
            onPressed: this.widget.onLike,
          ),
          Text(this.widget.activity.likedCount.toString(), style: kTextStyle),
          Spacer(),
          IconButton(
            icon: Icon(MdiIcons.commentOutline),
            onPressed: () {
              //TODO: set focus on comment ?
              // should we do something about it ?
            },
          ),
          Text(this.widget.activity.commentCount.toString(), style: kTextStyle),
          SizedBox(width: spacing),
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

  Widget buildPostImages({
    BuildContext context,
  }) {
    var images = this.widget.activity.images;
    var count = images.length;
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
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  void removeAsset(int index) {
    setState(() {
      provider.picked.removeAt(index);
    });
  }

  Future<void> createComment() async {
    debugPrint("Send a comment");
    var cUser = Provider.of<CurrentUser>(context, listen: false);
    var service = Provider.of<LocalImageService>(context, listen: false);
    var gallery = <LokalImages>[];
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

    var success =
        await Provider.of<Activities>(context, listen: false).createComment(
      authToken: cUser.idToken,
      activityId: widget.activity.id,
      body: body,
    );

    if (success) {
      commentInputController.clear();
      setState(() {
        provider.picked.clear();
      });
      Provider.of<Activities>(context, listen: false).fetchComments(
        authToken: cUser.idToken,
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

  Widget buildCommentInputImages(BuildContext context) {
    if (provider.picked.length <= 0) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      addRepaintBoundaries: true,
      itemCount: provider.picked.length,
      itemBuilder: (ctx, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 0.5),
          height: 100,
          width: 100,
          child: AssetPhotoThumbnail(
            galleryItem: provider.picked[index],
            onTap: () => openInputGallery(
              context,
              index,
              provider.picked,
            ),
            onRemove: () => setState(() => provider.picked.removeAt(index)),
            fit: BoxFit.cover,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCommentTextField(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: commentInputController,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        hintText: "Add a comment...",
        hintStyle: kTextStyle.copyWith(
          fontWeight: FontWeight.normal,
          color: Colors.grey[400],
        ),
        alignLabelWithHint: true,
        suffixIcon: Padding(
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: kTealColor,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: createComment,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCommentInput({BuildContext context}) {
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
                    child: buildCommentInputImages(context),
                  ),
                  buildCommentTextField(context),
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
    var user = Provider.of<Users>(context).findById(widget.activity.userId);
    var cUser = Provider.of<CurrentUser>(context, listen: false);
    var activities = Provider.of<Activities>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(
        backgroundColor: kTealColor,
        onPressedLeading: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 33,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => activities.fetchComments(
          authToken: cUser.idToken,
          activityId: widget.activity.id,
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.03,
                  ),
                  child: buildHeader(
                    firstName: user.firstName,
                    lastName: user.lastName,
                    photo: user.profilePhoto,
                    spacing: width * 0.02,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.03,
                    0.0,
                    width * 0.03,
                    height * 0.03,
                  ),
                  child: Text(
                    widget.activity.message,
                    softWrap: true,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: buildPostImages(context: context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.02,
                  ),
                  child: Text(
                    DateFormat("hh:mm a • dd MMMM yyyy")
                        .format(widget.activity.createdAt),
                    style: kTextStyle.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                buildLikeAndCommentRow(spacing: width * 0.03),
                SizedBox(
                  height: height * 0.02,
                ),
                Consumer<Activities>(
                  builder: (context, activities, child) {
                    return activities.isCommentLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.activity.comments?.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var comment = widget.activity.comments[index];
                              var commentUser =
                                  Provider.of<Users>(context, listen: false)
                                      .findById(comment.userId);

                              return Column(
                                children: [
                                  CommentCard(
                                    user: commentUser,
                                    message: comment.message,
                                    images: comment.images ?? [],
                                    onLongPress: this.onCommentLongPress,
                                    onUserPressed: widget.onUserPressed,
                                    onLike: () {
                                      debugPrint("Liked comment ${comment.id}");
                                    },
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          );
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: buildCommentInput(context: context),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: this.showImagePicker ? 200.0 : 0.0,
                  child: ImageGalleryPicker(
                    provider,
                    pickerHeight: 200,
                    assetHeight: 200,
                    assetWidth: 200,
                    thumbSize: 200,
                    enableSpecialItemBuilder: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
