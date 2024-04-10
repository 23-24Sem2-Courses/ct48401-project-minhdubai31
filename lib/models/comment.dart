import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String content;
  final String ownerUserId;
  final String postId;
  final Timestamp createdAt;

  Comment({
    required this.content,
    required this.postId,
    required this.ownerUserId,
    required this.createdAt,
  });

  Comment copyWith({
    String? content,
    String? postId,
    String? ownerUserId,
    Timestamp? createdAt,
  }) {
    return Comment(
      content: content ?? this.content,
      postId: postId ?? this.postId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Comment.fromJson(Map<String, dynamic> json)
      : this(
          content: json["content"] as String,
          postId: json["postId"] as String,
          ownerUserId: json["owner"] as String,
          createdAt: json["createdAt"] as Timestamp,
        );

  Map<String, dynamic> toJson() => {
        "content": content,
        "postId": postId,
        "owner": ownerUserId,
        "createdAt": createdAt,
      };
}
