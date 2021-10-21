import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_feed.dart';
import '../../../models/lokal_images.dart';
import '../../../providers/users.dart';
import '../../../widgets/photo_view_gallery/gallery/gallery_network_photo_view.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class PostCard extends StatelessWidget {
  final ActivityFeed activityFeed;
  final Function() onCommentsPressed;
  final Function() onLike;
  final Function() onTripleDotsPressed;
  final Function() onUserPressed;
  final Function() onMessagePressed;
  PostCard({
    required this.activityFeed,
    required this.onCommentsPressed,
    required this.onLike,
    required this.onTripleDotsPressed,
    required this.onUserPressed,
    required this.onMessagePressed,
  });

  Widget _buildHeader(BuildContext context) {
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
      title: GestureDetector(
        onTap: this.onUserPressed,
        child: Row(
          children: [
            Text(
              "${user.firstName} ${user.lastName}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              createdSince,
              style: Theme.of(context).textTheme.subtitle2,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.black),
        onPressed: this.onTripleDotsPressed,
      ),
    );
  }

  Widget _buildMessageBody({
    required String message,
    double horizontalPadding = 8.0,
  }) {
    return GestureDetector(
      onTap: this.onMessagePressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(
          message,
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

  void _openGallery(
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

  Widget _buildPostImages({
    BuildContext? context,
  }) {
    var images = this.activityFeed.images;
    var count = images.length;
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: count,
      crossAxisCount: 2,
      itemBuilder: (ctx, index) {
        return NetworkPhotoThumbnail(
          galleryItem: images[index],
          onTap: () => _openGallery(context!, index, images),
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<Users>(builder: (context, users, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Card(
          margin: EdgeInsets.only(top: height * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          child: users.isLoading!
              ? Container(
                  height: 100.0.h,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.0.h),
                    _buildHeader(context),
                    SizedBox(height: 5.0.h),
                    _buildMessageBody(
                      message: activityFeed.message,
                      horizontalPadding: 20.0.w,
                    ),
                    SizedBox(height: 5.0.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: _buildPostImages(context: context),
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
                              this.activityFeed.liked
                                  ? MdiIcons.heart
                                  : MdiIcons.heartOutline,
                              color: this.activityFeed.liked
                                  ? Colors.red
                                  : Colors.black,
                            ),
                            onPressed: this.onLike,
                          ),
                          Text(
                            this.activityFeed.likedCount.toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(MdiIcons.commentOutline),
                                onPressed: () => this.onCommentsPressed(),
                              ),
                              Text(
                                this.activityFeed.commentCount.toString(),
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
      );
    });
  }
}
