import 'dart:io';

import 'package:flutter/material.dart';

class GalleryFilePhotoThumbnail extends StatelessWidget {
  const GalleryFilePhotoThumbnail({
    Key key,
    @required this.galleryItem,
    @required this.onTap,
  }) : super(key: key);

  final File galleryItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryItem.absolute,
          child: Image.file(
            galleryItem,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
