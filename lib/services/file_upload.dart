import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileUploadService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadFile(
      {required File file, required String userUid}) async {
    try {
      String? downloadUrl;
      Reference storageRef =
          _firebaseStorage.ref().child("profile_images").child("$userUid.jpg");

      UploadTask storageUploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await storageUploadTask
          .whenComplete(() => storageRef.getDownloadURL());

      downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }
}
