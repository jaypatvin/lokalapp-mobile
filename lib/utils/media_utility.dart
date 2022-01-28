import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaUtility {
  final ImagePicker imagePicker = ImagePicker();

  Future<File?> _pickFile(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  /// Shows the dialog to the user. [BuildContext] is required for the
  /// engine to determine where to draw the dialog.
  Future<File?> showMediaDialog(BuildContext parentContext) async {
    return showDialog<File>(
      context: parentContext,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: const Text('Upload Picture'),
            content: const Text('Choose image source:'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Camera'),
                onPressed: () async {
                  final file = await _pickFile(ImageSource.camera);
                  Navigator.pop(context, file);
                },
              ),
              CupertinoDialogAction(
                child: const Text('Gallery'),
                onPressed: () async {
                  final file = await _pickFile(ImageSource.gallery);
                  Navigator.pop(context, file);
                },
              ),
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }

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
