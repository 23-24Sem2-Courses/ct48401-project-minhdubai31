import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct484_project/models/comment.dart';

const String commentsCollectionRef = "comments";

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference _commentsRef;

  CommentService() {
    _commentsRef =
        _firestore.collection(commentsCollectionRef).withConverter<Comment>(
              fromFirestore: (snapshot, option) =>
                  Comment.fromJson(snapshot.data()!),
              toFirestore: (comment, option) => comment.toJson(),
            );
  }

  Stream<QuerySnapshot> getComments() {
    return _commentsRef.orderBy("createdAt", descending: true).snapshots();
  }

  Stream<QuerySnapshot> getCommentsOfPost(String postId) {
    return _commentsRef
        .where("postId", isEqualTo: postId)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> createComment(Comment comment) async {
    await _commentsRef.add(comment);
  }

  Future<void> updateComment(String commentId, Comment comment) async {
    await _commentsRef.doc(commentId).update(comment.toJson());
  }

  Future<void> deleteComment(String commentId) async {
    await _commentsRef.doc(commentId).delete();
  }
}
