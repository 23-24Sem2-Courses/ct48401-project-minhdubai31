class Post {
  final String id;
  final String ownerUserId;
  final String caption;
  final String totalLike;
  final String imageUrl;
  final List<String> likesUserIdList;

  Post({
    required this.id,
    required this.ownerUserId,
    required this.caption,
    required this.totalLike,
    required this.imageUrl,
    required this.likesUserIdList,
  });

  Post copyWith({
    String? id,
    String? ownerUserId,
    String? caption,
    String? totalLike,
    String? imageUrl,
    List<String>? likesUserIdList,
  }) {
    return Post(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      caption: caption ?? this.caption,
      totalLike: totalLike ?? this.totalLike,
      imageUrl: imageUrl ?? this.imageUrl,
      likesUserIdList: likesUserIdList ?? this.likesUserIdList,
    );
  }
}
