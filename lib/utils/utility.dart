import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaUtility {
  static MediaUtility? _utility;
  final _picker = ImagePicker();

  static MediaUtility? get instance {
    return _utility ??= MediaUtility();
  }

  Future<File?> _pickFile(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  Future<File?> showMediaDialog(BuildContext parentContext) async {
    return showDialog<File>(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Upload Picture'),
          children: [
            SimpleDialogOption(
              child: const Text('Camera'),
              onPressed: () async {
                final file = await _pickFile(ImageSource.camera);
                Navigator.pop(context, file);
              },
            ),
            SimpleDialogOption(
              child: const Text('Gallery'),
              onPressed: () async {
                final file = await _pickFile(ImageSource.gallery);
                Navigator.pop(context, file);
              },
            ),
            SimpleDialogOption(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, null),
            )
          ],
        );
      },
    );
  }
}
