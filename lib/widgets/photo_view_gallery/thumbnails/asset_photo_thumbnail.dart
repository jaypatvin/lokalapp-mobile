import 'package:flutter/material.dart';
import 'package:lokalapp/widgets/photo_picker_gallery/custom_asset_widget.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetPhotoThumbnail extends StatelessWidget {
  const AssetPhotoThumbnail(
      {Key key,
      @required this.galleryItem,
      @required this.onTap,
      this.onRemove,
      this.fit = BoxFit.cover,
      this.decoration})
      : super(key: key);

  final AssetEntity galleryItem;
  final GestureTapCallback onTap;
  final GestureTapCallback onRemove;
  final BoxFit fit;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: this.decoration,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onTap,
              child: Hero(
                tag: galleryItem.title,
                child: Image(
                  alignment: Alignment.topCenter,
                  image: AssetEntityThumbImage(
                    entity: galleryItem,
                  ),
                  fit: this.fit,
                ),
              ),
            ),
          ),
          Positioned(
            top: 6.0,
            right: 6.0,
            child: GestureDetector(
              onTap: this.onRemove,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
