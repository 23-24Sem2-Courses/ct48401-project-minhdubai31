class User {
  final String name;
  final String avatarUrl;
  final String avatarFileName;
  final String email;
  final List<dynamic> postsId;
  final String biography;

  User({
    required this.name,
    required this.avatarUrl,
    required this.avatarFileName,
    required this.email,
    required this.postsId,
    required this.biography,
  });

  User copyWith({
    String? name,
    String? avatarUrl,
    String? avatarFileName,
    String? email,
    List<dynamic>? postsId,
    String? biography,
  }) {
    return User(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarFileName: avatarFileName ?? this.avatarFileName,
      email: email ?? this.email,
      postsId: postsId ?? this.postsId,
      biography: biography ?? this.biography,
    );
  }

  User.fromJson(Map<String, dynamic> json)
      : this(
          name: json["name"] as String,
          avatarUrl: json["avatarUrl"] as String,
          avatarFileName: json["avatarFileName"] as String,
          email: json["email"] as String,
          postsId: json["postsId"] as List<dynamic>,
          biography: json["biography"] as String,
        );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "postsId": postsId,
        "avatarUrl": avatarUrl,
        "avatarFileName": avatarFileName,
        "biography": biography,
      };
}
