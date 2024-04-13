import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String ownerUserId;
  final String caption;
  final String imageUrl;
  final String imageFileName;
  final List<dynamic> likesUserIdList;
  final Timestamp createdAt;

  Post({
    required this.ownerUserId,
    required this.caption,
    required this.imageUrl,
    required this.imageFileName,
    required this.likesUserIdList,
    required this.createdAt,
  });

  Post copyWith({
    String? ownerUserId,
    String? caption,
    String? imageUrl,
    String? imageFileName,
    List<dynamic>? likesUserIdList,
    Timestamp? createdAt,
  }) {
    return Post(
      ownerUserId: ownerUserId ?? this.ownerUserId,
      caption: caption ?? this.caption,
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
          imageUrl: json["imageUrl"] as String,
          imageFileName: json["imageFileName"] as String,
          likesUserIdList: json["likesUserIdList"] as List<dynamic>,
          createdAt: json["createdAt"] as Timestamp,
        );

  Map<String, dynamic> toJson() => {
    "ownerUserId": ownerUserId,
    "caption": caption,
    "imageUrl": imageUrl,
    "imageFileName": imageFileName,
    "likesUserIdList": likesUserIdList,
    "createdAt": createdAt,
  };
}
