import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String ownerUserId;
  final String caption;
  final int totalLike;
  final String imageUrl;
  final String imageFileName;
  final List<dynamic> likesUserIdList;
  final Timestamp createdAt;

  Post({
    required this.ownerUserId,
    required this.caption,
    required this.totalLike,
    required this.imageUrl,
    required this.imageFileName,
    required this.likesUserIdList,
    required this.createdAt,
  });

  Post copyWith({
    String? ownerUserId,
    String? caption,
    int? totalLike,
    String? imageUrl,
    String? imageFileName,
    List<dynamic>? likesUserIdList,
    Timestamp? createdAt,
  }) {
    return Post(
      ownerUserId: ownerUserId ?? this.ownerUserId,
      caption: caption ?? this.caption,
      totalLike: totalLike ?? this.totalLike,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFileName: imageFileName ?? this.imageFileName,
      likesUserIdList: likesUserIdList ?? this.likesUserIdList,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Post.fromJson(Map<String, dynamic> json)
      : this(
          ownerUserId: json["ownerUserId"] as String,
          caption: json["caption"] as String,
          totalLike: json["totalLike"] as int,
          imageUrl: json["imageUrl"] as String,
          imageFileName: json["imageFileName"] as String,
          likesUserIdList: json["likesUserIdList"] as List<dynamic>,
          createdAt: json["createdAt"] as Timestamp,
        );

  Map<String, dynamic> toJson() => {
    "ownerUserId": ownerUserId,
    "caption": caption,
    "totalLike": totalLike,
    "imageUrl": imageUrl,
    "imageFileName": imageFileName,
    "likesUserIdList": likesUserIdList,
    "createdAt": createdAt,
  };
}
