import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImage({
    required File file,
    required String src,
    required String fileName,
  }) async {
    final UploadTask uploadTask =
        storageRef.child('/images/$src/$fileName.jpg').putFile(file);
    final TaskSnapshot storageSnap = await uploadTask;
    final String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
}
