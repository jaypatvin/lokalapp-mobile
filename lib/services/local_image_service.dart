import 'dart:io';

import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';

class LocalImageService {
  final Uuid _uuid = Uuid();
  static LocalImageService? _service;

  static LocalImageService? get instance {
    if (_service == null) {
      _service = LocalImageService();
    }
    return _service;
  }

  Future<String> uploadImage({required File file, String name = ''}) async {
    // create a new file name from Uuid()
    var fileName = '$name\_${_uuid.v4()}';
    var compressedFile = await _compressImage(file, fileName);
    return await Database().uploadImage(compressedFile, fileName);
  }

  Future<File> _compressImage(File file, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$fileName.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 90));
    return compressedImageFile;
  }
}
