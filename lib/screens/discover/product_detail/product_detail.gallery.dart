import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../models/product.dart';

class ProductDetailGallery extends StatelessWidget {
  final Product? product;
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
    final gallery = product!.gallery;
    if (gallery == null || gallery.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: const Center(child: Text('No Images')),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: product!.gallery!.length,
            onPageChanged: onPageChanged,
            gaplessPlayback: true,
            builder: (context, index) {
              final image = product!.gallery![index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(image.url),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
                disableGestures: true,
                controller: controller,
                errorBuilder: (ctx, _, __) => const SizedBox.shrink(),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).canvasColor,
            ),
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: gallery.map((url) {
                final int index = gallery.indexOf(url);
                return Container(
                  width: 9.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                    color: currentIndex == index
                        ? const Color.fromRGBO(0, 0, 0, 0.9)
                        : Colors.grey,
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
