import 'dart:io';

import 'package:image/image.dart' as im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'database.dart';

class LocalImageService {
  final Uuid _uuid = const Uuid();
  static LocalImageService? _service;

  static LocalImageService? get instance {
    return _service ??= LocalImageService();
  }

  Future<String> uploadImage({required File file, String name = ''}) async {
    // create a new file name from Uuid()
    final fileName = '${name}_${_uuid.v4()}';
    final compressedFile = await _compressImage(file, fileName);
    return Database().uploadImage(compressedFile, fileName);
  }

  Future<File> _compressImage(File file, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final im.Image imageFile = im.decodeImage(file.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$fileName.jpg')
      ..writeAsBytesSync(im.encodeJpg(imageFile, quality: 90));
    return compressedImageFile;
  }
}
