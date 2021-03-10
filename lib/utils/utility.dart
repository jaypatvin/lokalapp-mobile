import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lokalapp/services/local_image_service.dart';

class Utility {
  static Utility _utility;

  static Utility getInstance() {
    if (_utility == null) {
      _utility = Utility();
    }
    return _utility;
  }

  Future<File> showMediaDialog(BuildContext parentContext) async {
    var imageService = LocalImageService();
    return await showDialog<File>(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Upload Picture"),
          children: [
            SimpleDialogOption(
              child: Text("Camera"),
              onPressed: () async {
                var file = await imageService.launchCamera();
                Navigator.pop(context, file);
              },
            ),
            SimpleDialogOption(
              child: Text("Gallery"),
              onPressed: () async {
                var file = await imageService.launchGallery();
                Navigator.pop(context, file);
              },
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context, null),
            )
          ],
        );
      },
    );
  }
}
