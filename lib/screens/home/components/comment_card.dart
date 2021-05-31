import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/lokal_images.dart';
import '../../../models/lokal_user.dart';
import '../../../utils/functions.utils.dart';
import '../../../utils/themes.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class CommentCard extends StatelessWidget {
  final LokalUser user;
  final String message;
  final Function onLongPress;
  final Function(String) onUserPressed;
  final Function onLike;
  final List<LokalImages> images;
  final bool liked;

  const CommentCard({
    Key key,
    @required this.user,
    this.message,
    this.onLongPress,
    this.onUserPressed,
    this.onLike,
    this.images,
    this.liked = false,
  }) : super(key: key);

  Widget buildImages() {
    // return StaggeredGridView.countBuilder(
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemCount: images.length,
    //   crossAxisCount: 2,
    //   itemBuilder: (ctx, index) {
    //     return GalleryNetworkPhotoThumbnail(
    //       galleryItem: images[index],
    //       onTap: () => openGallery(ctx, index, images),
    //     );
    //   },
    //   staggeredTileBuilder: (index) {
    //     if (images.length % 2 != 0 && index == 0) {
    //       return new StaggeredTile.count(2, 0.5);
    //     }
    //     return new StaggeredTile.count(1, 0.5);
    //   },
    // );
    return Container(
      height: images.length > 0 ? 100 : 0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            width: 100,
            child: NetworkPhotoThumbnail(
              galleryItem: images[index],
              onTap: () => openGallery(context, index, images),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var photo = user.profilePhoto ?? "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onLongPress: this.onLongPress,
          leading: GestureDetector(
            onTap: () => this.onUserPressed(user.id),
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
                    ..onTap = () => this.onUserPressed(user.id),
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
              this.liked ? MdiIcons.heart : MdiIcons.heartOutline,
              color: this.liked ? Colors.red : Colors.black,
            ),
            onPressed: onLike,
          ),
        ),
        buildImages(),
      ],
    );
  }
}
