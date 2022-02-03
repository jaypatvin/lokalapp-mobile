import 'package:flutter/material.dart';

import '../../../models/lokal_images.dart';

class NetworkPhotoThumbnail extends StatelessWidget {
  const NetworkPhotoThumbnail({
    Key? key,
    required this.galleryItem,
    required this.onTap,
    this.fit = BoxFit.cover,
    this.heroTag,
  }) : super(key: key);

  final LokalImages galleryItem;
  final GestureTapCallback onTap;
  final BoxFit fit;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag ?? galleryItem.url,
        child: Image.network(
          galleryItem.url,
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
