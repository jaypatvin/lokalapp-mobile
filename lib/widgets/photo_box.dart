import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/themes.dart';

class PhotoBox extends StatelessWidget {
  final File file;
  final BoxShape shape;

  const PhotoBox({@required this.file, @required this.shape});

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
