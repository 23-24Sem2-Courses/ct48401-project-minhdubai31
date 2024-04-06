import 'package:ct484_project/models/post.dart';

class User {
  final String name;
  final String email;
  final List<Post> posts;

  User({
    required this.name,
    required this.email,
    required this.posts,
  });

  User copyWith({
    String? name,
    String? email,
    List<Post>? posts,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      posts: posts ?? this.posts,
    );
  }
}
