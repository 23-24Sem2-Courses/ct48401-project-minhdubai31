import 'package:ct484_project/models/user.dart';

class Post {
  final String id;
  final User owner;
  final String caption;
  final String totalLike;
  final String imageUrl;
  final List<User> likes;

  Post({
    required this.id,
    required this.owner,
    required this.caption,
    required this.totalLike,
    required this.imageUrl,
    required this.likes,
  });

  Post copyWith({
    String? id,
    User? owner,
    String? caption,
    String? totalLike,
    String? imageUrl,
    List<User>? likes,
  }) {
    return Post(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      caption: caption ?? this.caption,
      totalLike: totalLike ?? this.totalLike,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
    );
  }
}
