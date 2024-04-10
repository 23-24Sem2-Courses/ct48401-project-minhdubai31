import 'package:cached_network_image/cached_network_image.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_delete_confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import 'user_avatar_and_name.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final String postId;

  const PostCard({
    super.key,
    required this.post,
    required this.postId,
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

        List<PopupMenuItem> popupMenuItems = [];
        if (FirebaseAuth.instance.currentUser!.uid == widget.post.ownerUserId) {
          popupMenuItems = [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Ionicons.create_outline),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Edit this post"),
                ],
              ),
              onTap: () => Navigator.of(context).pushNamed(
                "/create_edit_post_screen",
                arguments: {"post": widget.post, "postId": widget.postId},
              ),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Ionicons.trash_bin_outline),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Delete this post"),
                ],
              ),
              onTap: () {
                showDeleteConfirmDialog(
                  context: context,
                  title: "Are you sure?",
                  content: "This action will permanently delete this post",
                  deleteMethod: () {
                    context.read<PostService>().deletePost(widget.postId);
                  },
                );
              },
            ),
          ];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AVATAR AND NAME
            UserAvatarAndName(
              user: user,
              popupMenuItems: popupMenuItems,
            ),
            const SizedBox(
              height: 8,
            ),
            AspectRatio(
              aspectRatio: 4 / 5,
              child: CachedNetworkImage(
                imageUrl: widget.post.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
