import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/failure_exception.dart';
import 'database.dart';

class LocalImageService {
  const LocalImageService({this.uuid = const Uuid()});

  final Uuid uuid;

  Future<String> uploadImage({
    required File file,
    required String src,
  }) async {
    final fileName = uuid.v4();
    final compressedFile = await _compressImage(file, fileName);
    if (compressedFile == null) {
      throw FailureException('Failed to create image');
    }

    return Database().uploadImage(
      file: compressedFile,
      fileName: fileName,
      src: src,
    );
  }

  // Future<File> _compressImage(File file, String fileName) async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   final im.Image imageFile = im.decodeImage(file.readAsBytesSync())!;
  //   final compressedImageFile = File('$path/img_$fileName.jpg')
  //     ..writeAsBytesSync(im.encodeJpg(imageFile));
  //   return compressedImageFile;
  // }
  Future<File?> _compressImage(File file, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${tempDir.absolute.path}/$fileName.jpg',
      quality: 90,
    );

    return result;
  }
}
