import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../models/product.dart';
import '../../../utils/constants/themes.dart';

class ProductDetailGallery extends StatelessWidget {
  final Product product;
  final int currentIndex;
  final PhotoViewController? controller;
  final void Function(int) onPageChanged;
  const ProductDetailGallery({
    Key? key,
    required this.product,
    required this.currentIndex,
    required this.controller,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.gallery?.isEmpty ?? true) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: const Center(child: Text('No Images')),
      );
    }
    final gallery = product.gallery!;
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: double.infinity,
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: gallery.length,
            onPageChanged: onPageChanged,
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (context, index) {
              final image = gallery[index];
              return PhotoViewGalleryPageOptions.customChild(
                child: CachedNetworkImage(
                  imageUrl: image.url,
                  fit: BoxFit.cover,
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
                disableGestures: true,
                controller: controller,
              );
            },
            backgroundDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).canvasColor,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: gallery.map((url) {
                final int index = gallery.indexOf(url);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: kOrangeColor,
                    ),
                    color: currentIndex == index
                        ? kOrangeColor
                        : Colors.transparent,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
