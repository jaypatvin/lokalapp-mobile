import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return GridView.builder(
      // This is okay as we will always display all the images for this screen
      // shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length + 1,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 85.0.h,
      ),
      itemBuilder: (BuildContext context, int index) {
        final imageSource = index == images.length
            ? const PhotoBoxImageSource()
            : images[index];
        return Container(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () => onSelectImage(index),
            child: PhotoBox(
              height: 85.0.h,
              width: 85.0.h,
              shape: BoxShape.rectangle,
              imageSource: imageSource,
            ),
          ),
        );
      },
    );
  }
}
