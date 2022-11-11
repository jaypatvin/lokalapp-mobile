import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../models/lokal_images.dart';

class NetworkPhotoThumbnail extends StatelessWidget {
  const NetworkPhotoThumbnail({
    Key? key,
    required this.galleryItem,
    required this.onTap,
    this.fit = BoxFit.cover,
    this.heroTag,
  }) : super(key: key);

  final ILokalImage galleryItem;
  final GestureTapCallback onTap;
  final BoxFit fit;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag ?? galleryItem.url,
        child: CachedNetworkImage(
          imageUrl: galleryItem.url,
          alignment: Alignment.topCenter,
          fit: fit,
          placeholder: (_, __) => Shimmer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          errorWidget: (ctx, url, err) =>
              const Center(child: Text('Error displaying image.')),
        ),
      ),
    );
  }
}
