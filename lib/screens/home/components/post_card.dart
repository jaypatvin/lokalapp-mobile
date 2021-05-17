import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_feed.dart';
import '../../../models/lokal_images.dart';
import '../../../providers/users.dart';
import '../../../utils/themes.dart';
import '../../../widgets/photo_view_gallery/gallery_network_photo_thumbnail.dart';
import '../../../widgets/photo_view_gallery/gallery_network_photo_view.dart';

class PostCard extends StatelessWidget {
  final ActivityFeed activityFeed;
  final Function() onCommentsPressed;
  final Function() onLike;
  final Function() onTripleDotsPressed;
  final Function() onUserPressed;
  final Function() onMessagePressed;
  PostCard({
    @required this.activityFeed,
    @required this.onCommentsPressed,
    @required this.onLike,
    @required this.onTripleDotsPressed,
    @required this.onUserPressed,
    @required this.onMessagePressed,
  });

  Widget buildComments() {
    return Row(
      children: [
        IconButton(
          icon: Icon(MdiIcons.commentOutline),
          onPressed: () => this.onCommentsPressed(),
        ),
        Text(this.activityFeed.commentCount.toString(), style: kTextStyle),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    var difference = DateTime.now().difference(this.activityFeed.createdAt);
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

    var user = Provider.of<Users>(context, listen: false)
        .findById(activityFeed.userId);

    var photo = user.profilePhoto ?? "";

    return ListTile(
      leading: GestureDetector(
        onTap: this.onUserPressed,
        child: CircleAvatar(
          backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
        ),
      ),
      //TODO: add mins. since created
      title: GestureDetector(
        onTap: this.onUserPressed,
        child: Row(
          children: [
            Text(
              "${user.firstName} ${user.lastName}",
              style: kTextStyle.copyWith(fontSize: 18.0),
            ),
            Text(
              createdSince,
              style: kTextStyle.copyWith(
                  fontSize: 18.0, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: this.onTripleDotsPressed,
      ),
    );
  }

  Widget buildMessageBody({
    @required String message,
    double horizontalPadding = 8.0,
  }) {
    return GestureDetector(
      onTap: this.onMessagePressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(
          message,
          style: TextStyle(fontFamily: "GoldplayBold", fontSize: 16),
          maxLines: 8,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
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
    var images = this.activityFeed.images;
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Consumer<Users>(builder: (context, users, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Card(
          margin: EdgeInsets.only(top: height * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: users.isLoading
              ? Container(
                  height: height * 0.20,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: height * 0.01),
                    buildHeader(context),
                    SizedBox(height: height * 0.02),
                    buildMessageBody(
                      message: activityFeed.message,
                      horizontalPadding: width * 0.05,
                    ),
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: buildPostImages(context: context),
                    ),
                    Divider(
                      color: Colors.grey,
                      indent: width * 0.05,
                      endIndent: width * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.02,
                        right: width * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(MdiIcons.heartOutline),
                            onPressed: this.onLike,
                          ),
                          Text(this.activityFeed.likedCount.toString(),
                              style: kTextStyle),
                          Spacer(),
                          buildComments(),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
