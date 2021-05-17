import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/lokal_images.dart';
import '../../models/lokal_user.dart';
import '../../providers/activities.dart';
import '../../providers/user.dart';
import '../../providers/users.dart';
import '../../utils/themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/photo_view_gallery/gallery_network_photo_thumbnail.dart';
import '../../widgets/photo_view_gallery/gallery_network_photo_view.dart';

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
              //TODO: set focus on comment
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

  Widget buildCommmentBody({
    @required LokalUser user,
    @required String message,
  }) {
    var photo = user.profilePhoto ?? "";
    return ListTile(
      onLongPress: onCommentLongPress,
      leading: GestureDetector(
        onTap: () => this.widget.onUserPressed(user.id),
        child: CircleAvatar(
          backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
        ),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${user.firstName} ${user.lastName}",
              style: kTextStyle.copyWith(
                color: Colors.black,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => this.widget.onUserPressed(user.id),
            ),
            TextSpan(
              text: " $message",
              style: kTextStyle.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          MdiIcons.heartOutline,
          color: Colors.black,
        ),
        onPressed: () {
          debugPrint("Pressed Like");
        },
      ),
    );
  }

  void openGallery(
    BuildContext context,
    final int index,
    final List<LokalImages> galleryItems,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryNetworkPhotoView(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
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
        return GalleryNetworkPhotoThumbnail(
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

  Widget buildCommentInput({BuildContext context}) {
    return TextField(
      maxLines: null,
      controller: commentInputController,
      decoration: InputDecoration(
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
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              30.0,
            ),
          ),
          borderSide: BorderSide(
            color: Colors.grey[200],
          ),
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.all(5.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: kTealColor,
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () async {
                debugPrint("Send a comment");
                var cUser = Provider.of<CurrentUser>(context, listen: false);
                Map<String, String> body = {
                  "user_id": cUser.id,
                  "message": commentInputController.text,
                };

                var success =
                    await Provider.of<Activities>(context, listen: false)
                        .createComment(
                  authToken: cUser.idToken,
                  activityId: widget.activity.id,
                  body: body,
                );

                if (success) {
                  commentInputController.clear();
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
              },
              color: Colors.white,
            ),
          ),
        ),
      ),
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
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => activities.fetchComments(
          authToken: cUser.idToken,
          activityId: widget.activity.id,
        ),
        child: SingleChildScrollView(
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
                                  buildCommmentBody(
                                    user: commentUser,
                                    message: comment.message,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
