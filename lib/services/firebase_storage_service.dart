import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

const String postStorageRef = 'posts/';
const String avatarStorageRef = 'avatar/';

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService(this._storage);

  Future<Map<String, String>> uploadPostImage(XFile xfile) async {
    final File file = File(xfile.path);
    String newName =
        postStorageRef + DateTime.timestamp().toString() + xfile.name;
    final Reference fileToUploadRef = _storage.ref().child(newName);
    return {
      "url": await fileToUploadRef
          .putFile(file)
          .then((value) => value.ref.getDownloadURL()),
      "name": newName
    };
  }

  Future<Map<String, String>> uploadAvatarImage(XFile xfile) async {
    final File file = File(xfile.path);
    String newName =
        avatarStorageRef + DateTime.timestamp().toString() + xfile.name;
    final Reference fileToUploadRef = _storage.ref().child(newName);
    return {
      "url": await fileToUploadRef
          .putFile(file)
          .then((value) => value.ref.getDownloadURL()),
      "name": newName
    };
  }

  Future<void> deleteImage(String fileName) async {
    await _storage.ref().child(fileName).delete();
  }


}
