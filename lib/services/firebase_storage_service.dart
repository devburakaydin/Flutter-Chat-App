import 'dart:io';

import 'package:chat_app/services/storege_base.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService implements StorageBase {
  firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;

  @override
  Future<String> uploadFile(String userID, String fileType, File yuklenecekDosya) async {
    var uploadTask =
        await _storage.ref().child(userID).child(fileType).child(fileType).putFile(yuklenecekDosya);
    String url = await uploadTask.ref.getDownloadURL();
    if (url.isNotEmpty) {
      return url;
    } else {
      return null;
    }
  }
}
