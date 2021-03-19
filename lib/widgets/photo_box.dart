import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/themes.dart';

//TODO: use these in screens using PhotoBoxes
class PhotoBox extends StatelessWidget {
  final File file;
  final BoxShape shape;
  final double width;
  final double height;

  const PhotoBox(
      {@required this.file,
      @required this.shape,
      this.width = 140.0,
      this.height = 150.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.0,
      height: 75.0,
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
