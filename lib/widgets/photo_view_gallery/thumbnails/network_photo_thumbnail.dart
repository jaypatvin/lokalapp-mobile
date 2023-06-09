import 'package:flutter/material.dart';

import '../../../models/lokal_images.dart';

class NetworkPhotoThumbnail extends StatelessWidget {
  const NetworkPhotoThumbnail({
    Key key,
    @required this.galleryItem,
    @required this.onTap,
  }) : super(key: key);

  final LokalImages galleryItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryItem.url,
          child: Image.network(
            galleryItem.url,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
