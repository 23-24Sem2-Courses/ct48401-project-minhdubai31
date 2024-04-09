import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'user_avatar_and_name.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final UserService userService = UserService();
    return FutureBuilder(
      future: userService.getUser(widget.post.ownerUserId),
      builder: (context, snapshot) {
        User? user = snapshot.data?.data() as User?;

        if (user == null) {
          return const Center(
            child: null,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AVATAR AND NAME
            UserAvatarAndName(user: user),
            const SizedBox(
              height: 8,
            ),
            AspectRatio(
              aspectRatio: 4 / 5,
              child: Image(
                image: NetworkImage(widget.post.imageUrl),
                fit: BoxFit.cover,
              ),
            ),

            // POST FOOTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("Tap detected");
                              },
                              child: const Icon(
                                Ionicons.heart_outline,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                print("Tap detected");
                              },
                              child: const Icon(
                                Ionicons.chatbox_outline,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "1.024 likes",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        ),
                      )
                    ],
                  ),
                  // POST CONTENT
                  Row(
                    children: [
                      Text(
                        "${user.name} ",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.post.caption,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Tap");
                    },
                    child: const Text(
                      "View all 4 comments",
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
