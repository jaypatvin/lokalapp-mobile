import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../utils/functions.utils.dart';
import 'photo_view_gallery/thumbnails/asset_photo_thumbnail.dart';

class InputImages extends StatelessWidget {
  final List<AssetEntity> pickedImages;
  final void Function(int) onImageRemove;
  const InputImages({
    Key key,
    @required this.pickedImages,
    @required this.onImageRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pickedImages.length <= 0) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      addRepaintBoundaries: true,
      itemCount: pickedImages.length,
      itemBuilder: (ctx, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 0.5),
          height: 100,
          width: 100,
          child: AssetPhotoThumbnail(
            galleryItem: pickedImages[index],
            onTap: () => openInputGallery(
              context,
              index,
              pickedImages,
            ),
            onRemove: () => onImageRemove(index),
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
}
