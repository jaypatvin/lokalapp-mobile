import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class LocalImageService extends ChangeNotifier {
  String _mediaUrl;
  String _fileName;
  File _file;
  final Uuid _uuid = Uuid();
  final picker = ImagePicker();

  String get mediaUrl => _mediaUrl;
  File get file => _file;
  bool get fileExists => _file != null;

  Future<File> launchCamera() async {
    _mediaUrl = null;
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      return _file = File(pickedImage.path);
    }
    notifyListeners();
    return null;
  }

  Future<File> launchGallery() async {
    _mediaUrl = null;
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return _file = File(pickedImage.path);
    }
    notifyListeners();
    return null;
  }

  Future<String> uploadImage() async {
    // create a new file name from Uuid()
    _fileName = _uuid.v4();
    await _compressImage();
    _mediaUrl = await Database().uploadImage(_file, _fileName);
    // after uploading, clear file picked
    _file = null;
    // since we cannot clear _mediaUrl after using it, we need to use fileExists to determine states
    return _mediaUrl;
  }

  Future<void> _compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$_fileName.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 90));
    _file = compressedImageFile;
  }
}
