import 'package:flutter/material.dart';

import '../../../../widgets/photo_box.dart';

class AddProductGallery extends StatelessWidget {
  const AddProductGallery({
    Key? key,
    this.images = const [],
    required this.onSelectImage,
  }) : super(key: key);

  final List<PhotoBoxImageSource> images;
  final void Function(int index) onSelectImage;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (ctx, index) => const SizedBox(width: 8),
      itemCount: images.length + 1,
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        final imageSource = index == images.length
            ? const PhotoBoxImageSource()
            : images[index];
        return GestureDetector(
          onTap: () => onSelectImage(index),
          child: PhotoBox(
            height: 85,
            width: 85,
            shape: BoxShape.rectangle,
            imageSource: imageSource,
          ),
        );
      },
    );
    // return GridView.builder(
    //   // This is okay as we will always display all the images for this screen
    //   // shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   itemCount: images.length + 1,
    //   padding: EdgeInsets.zero,
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 4,
    //     mainAxisExtent: 85.0.h,
    //   ),
    //   itemBuilder: (BuildContext context, int index) {
    //     final imageSource = index == images.length
    //         ? const PhotoBoxImageSource()
    //         : images[index];
    //     return Container(
    //       padding: const EdgeInsets.all(5),
    //       child: GestureDetector(
    //         onTap: () => onSelectImage(index),
    //         child: PhotoBox(
    //           height: 85.0.h,
    //           width: 85.0.h,
    //           shape: BoxShape.rectangle,
    //           imageSource: imageSource,
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
