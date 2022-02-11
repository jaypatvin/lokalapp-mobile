import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/constants/themes.dart';

class PhotoBoxImageSource {
  const PhotoBoxImageSource({this.file, this.url});
  final File? file;
  final String? url;

  bool get isEmpty => file == null && (url?.isEmpty ?? true);
  bool get isNotEmpty => file != null || (url?.isNotEmpty ?? false);
  bool get isFile => file != null;
  bool get isUrl => url?.isNotEmpty ?? false;
}

class PhotoBox extends StatelessWidget {
  final PhotoBoxImageSource imageSource;
  final BoxShape shape;
  final double width;
  final double height;
  final bool displayBorder;

  const PhotoBox({
    required this.shape,
    this.imageSource = const PhotoBoxImageSource(),
    this.width = 150.0,
    this.height = 150.0,
    this.displayBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        border: displayBorder ? Border.all(color: kTealColor) : null,
        color: Colors.transparent,
      ),
      child: imageSource.isEmpty
          ? const Icon(
              Icons.add,
              color: kTealColor,
              size: 15,
            )
          : Image(
              fit: BoxFit.cover,
              image: imageSource.isFile
                  ? FileImage(imageSource.file!) as ImageProvider<FileImage>
                  : CachedNetworkImageProvider(imageSource.url!)
                      as ImageProvider<CachedNetworkImageProvider>,
              errorBuilder: (ctx, e, stack) => const Center(
                child: Text('Error displaying image'),
              ),
            ),
    );
  }
}
