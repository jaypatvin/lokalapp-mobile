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
    // return ListView.builder(
    //   itemCount: images.length + 1,
    //   scrollDirection: Axis.horizontal,
    //   itemBuilder: (BuildContext context, int index) {
    //     final imageSource = index == images.length
    //         ? const PhotoBoxImageSource()
    //         : images[index];
    //     return GestureDetector(
    //       key: ValueKey(
    //         imageSource.file?.absolute.path ?? imageSource.url ?? 'add_photo',
    //       ),
    //       onTap: () => onSelectImage(index),
    //       child: Card(
    //         margin: const EdgeInsets.all(5.0),
    //         child: PhotoBox(
    //           shape: BoxShape.rectangle,
    //           imageSource: imageSource,
    //           height: 75.0,
    //           width: 75.0,
    //         ),
    //       ),
    //     );
    //   },
    // );
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
              shape: BoxShape.rectangle,
              imageSource: imageSource,
            ),
          ),
        );
      },
    );
  }
}

// class AddProductGallery extends StatefulWidget {
//   const AddProductGallery({
//     Key? key,
//     this.images = const [],
//     required this.onSelectImage,
//   }) : super(key: key);

//   final List<PhotoBoxImageSource> images;
//   final void Function(int index) onSelectImage;

//   @override
//   _AddProductGalleryState createState() => _AddProductGalleryState();
// }

// class _AddProductGalleryState extends State<AddProductGallery> {
//   final boxShape = BoxShape.rectangle;
//   final double height = 75.0;
//   final double width = 75.0;

//   final List<PhotoBox> _photoBoxes = [];

//   @override
//   void initState() {
//     super.initState();

//     if (widget.images.isNotEmpty) {
//       for (final image in widget.images) {
//         _photoBoxes.add(
//           PhotoBox(
//             imageSource: image,
//             shape: boxShape,
//             width: width,
//             height: height,
//           ),
//         );
//       }
//     }

//     _photoBoxes.add(
//       PhotoBox(
//         shape: boxShape,
//         width: width,
//         height: height,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       // This is okay as we will always display all the images for this screen
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: _photoBoxes.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//       ),
//       itemBuilder: (BuildContext context, int index) {
//         return GestureDetector(
//           onTap: () => widget.onSelectImage(index),
//           child: Card(
//             margin: const EdgeInsets.all(5.0),
//             child: _photoBoxes[index],
//           ),
//         );
//       },
//     );
//   }
// }
