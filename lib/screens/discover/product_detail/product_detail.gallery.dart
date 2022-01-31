import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
                child: Image.network(
                  image.url,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (ctx, _, __) => const SizedBox.shrink(),
                  loadingBuilder: (context, child, event) {
                    if (event == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                          value: event.expectedTotalBytes != null
                              ? event.cumulativeBytesLoaded /
                                  event.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
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
