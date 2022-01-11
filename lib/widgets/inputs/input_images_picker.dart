import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../utils/functions.utils.dart';
import '../photo_view_gallery/thumbnails/asset_photo_thumbnail.dart';

class InputImagesPicker extends StatelessWidget {
  final List<AssetEntity> pickedImages;
  final void Function(int) onImageRemove;
  const InputImagesPicker({
    Key? key,
    required this.pickedImages,
    required this.onImageRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pickedImages.isEmpty) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: pickedImages.length,
      itemBuilder: (ctx, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.5),
          height: 90.h,
          width: 90.h,
          child: AssetPhotoThumbnail(
            galleryItem: pickedImages[index],
            onTap: () => openInputGallery(
              context,
              index,
              pickedImages,
            ),
            onRemove: () => onImageRemove(index),
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
