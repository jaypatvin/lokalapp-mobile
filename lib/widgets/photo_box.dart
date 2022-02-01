import 'dart:io';

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
    this.width = 140.0,
    this.height = 150.0,
    this.displayBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: imageSource.isEmpty
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: imageSource.isFile
                    ? FileImage(imageSource.file!) as ImageProvider<FileImage>
                    : NetworkImage(imageSource.url!)
                        as ImageProvider<NetworkImage>,
              ),
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
          : null,
    );
  }
}
