import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/failure_exception.dart';
import 'database/database.dart';

class LocalImageService {
  const LocalImageService({required this.database, this.uuid = const Uuid()});

  final Uuid uuid;
  final Database database;

  Future<String> uploadImage({
    required File file,
    required String src,
  }) async {
    try {
      final fileName = uuid.v4();
      final compressedFile = await _compressImage(file, fileName);
      if (compressedFile == null) {
        throw FailureException('Failed to create image');
      }

      return database.storage.uploadImage(
        file: compressedFile,
        fileName: fileName,
        src: src,
      );
    } catch (e) {
      rethrow;
    }
  }

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
