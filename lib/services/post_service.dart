import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/services/firebase_storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String postsCollectionRef = "posts";

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference _postsRef;

  PostService() {
    _postsRef = _firestore.collection(postsCollectionRef).withConverter<Post>(
          fromFirestore: (snapshot, option) => Post.fromJson(snapshot.data()!),
          toFirestore: (post, option) => post.toJson(),
        );
  }

  Stream<QuerySnapshot> getPosts() {
    return _postsRef.orderBy("createdAt", descending: true).snapshots();
  }

  Stream<QuerySnapshot> getPostsOfUser(String userId) {
    return _postsRef
        .where("ownerUserId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> createPost(Post post) async {
    await _postsRef.add(post);
  }

  Future<void> updatePost(String postId, Post post) async {
    await _postsRef.doc(postId).update(post.toJson());
  }

  Future<void> deletePost(String postId, Post post) async {
    await _postsRef.doc(postId).delete();
    await FirebaseStorageService(FirebaseStorage.instance).deletePostImage(post.imageFileName);
  }
}
