class User {
  final String name;
  final String avatarUrl;
  final String email;
  final List<dynamic> postsId;

  User({
    required this.name,
    required this.avatarUrl,
    required this.email,
    required this.postsId,
  });

  User copyWith({
    String? name,
    String? avatarUrl,
    String? email,
    List<dynamic>? postsId,
  }) {
    return User(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      postsId: postsId ?? this.postsId,
    );
  }

  User.fromJson(Map<String, dynamic> json)
      : this(
          name: json["name"] as String,
          avatarUrl: json["avatarUrl"] as String,
          email: json["email"] as String,
          postsId: json["postsId"] as List<dynamic>,
        );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "postsId": postsId,
        "avatarUrl": avatarUrl,
      };
}
