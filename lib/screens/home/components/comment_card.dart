import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../models/lokal_images.dart';
import '../../../models/lokal_user.dart';
import '../../../utils/functions.utils.dart';
import '../../../widgets/photo_view_gallery/thumbnails/network_photo_thumbnail.dart';

class CommentCard extends StatelessWidget {
  final LokalUser user;
  final String? message;
  final Function? onLongPress;
  final Function(String)? onUserPressed;
  final Function? onLike;
  final List<LokalImages>? images;
  final bool? liked;

  const CommentCard({
    Key? key,
    required this.user,
    this.message,
    this.onLongPress,
    this.onUserPressed,
    this.onLike,
    this.images,
    this.liked = false,
  }) : super(key: key);

  Widget _buildImages() {
    return Container(
      height: images!.length > 0 ? 95.h : 0,
      //padding: EdgeInsets.symmetric(horizontal: 20.0.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: images!.length,
        itemBuilder: (context, index) {
          return Container(
            height: 95.h,
            width: 95.h,
            child: NetworkPhotoThumbnail(
              galleryItem: images![index],
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
    return InkWell(
      onLongPress: this.onLongPress as void Function()?,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            //onLongPress: this.onLongPress,
            leading: GestureDetector(
              onTap: () => this.onUserPressed!(user.id!),
              child: CircleAvatar(
                radius: 18.0.r,
                backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${user.firstName} ${user.lastName}",
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.black,
                        ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => this.onUserPressed!(user.id!),
                  ),
                  TextSpan(
                    text: " $message",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(
                this.liked! ? MdiIcons.heart : MdiIcons.heartOutline,
                color: this.liked! ? Colors.red : Colors.black,
              ),
              onPressed: onLike as void Function()?,
            ),
          ),
          _buildImages(),
        ],
      ),
    );
  }
}
