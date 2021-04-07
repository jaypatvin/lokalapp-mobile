import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/themes.dart';

class PhotoBox extends StatelessWidget {
  final File file;
  final BoxShape shape;
  final double width;
  final double height;

  const PhotoBox(
      {@required this.file,
      @required this.shape,
      this.width = 140.0, //140.0 //72.0
      this.height = 150.0}); //150.0 //75.0

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        image: file == null
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(file),
              ),
        shape: shape,
        border: Border.all(width: 1, color: kTealColor),
      ),
      child: file == null
          ? Icon(
              Icons.add,
              color: kTealColor,
              size: 15,
            )
          : null,
    );
  }
}
