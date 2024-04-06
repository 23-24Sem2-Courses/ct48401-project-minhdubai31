import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';

class Comment {
  final String content;
  final User owner;
  final Post post;
  final List<Comment> replies;

  Comment({
    required this.content,
    required this.post,
    required this.owner,
    required this.replies,
  });

  Comment copyWith({
    String? content,
    Post? post,
    User? owner,
    List<Comment>? replies,
  }) {
    return Comment(
      content: content ?? this.content,
      post: post ?? this.post,
      owner: owner ?? this.owner,
      replies: replies ?? this.replies,
    );
  }
}
