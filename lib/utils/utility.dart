import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaUtility {
  static MediaUtility _utility;
  final _picker = ImagePicker();

  static MediaUtility get instance {
    if (_utility == null) {
      _utility = MediaUtility();
    }
    return _utility;
  }

  Future<File> _pickFile(ImageSource source) async {
    final pickedImage = await _picker.getImage(source: source);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  Future<File> showMediaDialog(BuildContext parentContext) async {
    return await showDialog<File>(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Upload Picture"),
          children: [
            SimpleDialogOption(
              child: Text("Camera"),
              onPressed: () async {
                var file = await _pickFile(ImageSource.camera);
                Navigator.pop(context, file);
              },
            ),
            SimpleDialogOption(
              child: Text("Gallery"),
              onPressed: () async {
                var file = await _pickFile(ImageSource.gallery);
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
