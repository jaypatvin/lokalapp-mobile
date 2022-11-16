import 'dart:io';

import 'package:flutter/material.dart';

class FilePhotoThumbnail extends StatelessWidget {
  const FilePhotoThumbnail({
    super.key,
    required this.galleryItem,
    required this.onTap,
    this.fit = BoxFit.cover,
    this.heroTag,
  });

  final File galleryItem;

  final GestureTapCallback onTap;
  final BoxFit fit;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag ?? galleryItem.absolute,
        child: Image.file(
          galleryItem,
          alignment: Alignment.topCenter,
          fit: fit,
          errorBuilder: (ctx, e, stack) => const Center(
            child: Text('Error displaying image.'),
          ),
        ),
      ),
    );
  }
}
