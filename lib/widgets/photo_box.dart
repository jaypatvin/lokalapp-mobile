import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/themes.dart';

class PhotoBox extends StatelessWidget {
  final File? file;
  final BoxShape shape;
  final double width;
  final double height;
  final String? url;
  final bool displayBorder;

  const PhotoBox({
    required this.shape,
    this.file,
    this.url = '',
    this.width = 140.0, //140.0 //72.0
    this.height = 150.0,
    this.displayBorder = true,
  }); //150.0 //75.0

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        image: file == null && this.url!.isEmpty
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: (file != null ? FileImage(file!) : NetworkImage(this.url!)) as ImageProvider<Object>,
              ),
        shape: shape,
        border: displayBorder ? Border.all(width: 1, color: kTealColor) : null,
        color: Colors.transparent,
      ),
      child: file == null && this.url!.isEmpty
          ? Icon(
              Icons.add,
              color: kTealColor,
              size: 15,
            )
          : null,
    );
  }
}
