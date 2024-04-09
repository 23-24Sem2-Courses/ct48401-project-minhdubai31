import 'package:ct484_project/models/user.dart';
import 'package:flutter/material.dart';

class UserAvatarAndName extends StatelessWidget {
  const UserAvatarAndName({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    ImageProvider avatar = const AssetImage('assets/avatar.png');

    if (user.avatarUrl != "") {
      avatar = NetworkImage(user.avatarUrl);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 35,
            height: 35,
            child: CircleAvatar(backgroundImage: avatar),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          )
        ],
      ),
    );
  }
}
