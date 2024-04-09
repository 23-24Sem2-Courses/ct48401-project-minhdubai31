import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

const String postStorageRef = 'posts/';
const String avatarStorageRef = 'avatar/';

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService(this._storage);

  Future<String> uploadPostImage(XFile xfile) async {
    final File file = File(xfile.path);
    final Reference fileToUploadRef = _storage
        .ref()
        .child(postStorageRef + DateTime.timestamp().toString() + xfile.name);
    return await fileToUploadRef
        .putFile(file)
        .then((value) => value.ref.getDownloadURL());
  }

  Future<String> uploadAvatarImage(XFile xfile) async {
    final File file = File(xfile.path);
    final Reference fileToUploadRef = _storage
        .ref()
        .child(avatarStorageRef + DateTime.timestamp().toString() + xfile.name);
    return await fileToUploadRef
        .putFile(file)
        .then((value) => value.ref.getDownloadURL());
  }
}
