import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/widgets/user_avatar_and_name.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../widgets/post_preview_tile.dart';

class UserTabScreen extends StatefulWidget {
  static const routeName = "/user_tab_screen";
  const UserTabScreen({super.key, required this.userId});
  final String userId;

  @override
  State<UserTabScreen> createState() => _UserTabScreenState();
}

class _UserTabScreenState extends State<UserTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: widget.userId != FirebaseAuth.instance.currentUser!.uid
          ? AppBar()
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // AVATAR AND NAME
            StreamBuilder(
                stream: context.read<UserService>().getUsers(),
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: context.read<UserService>().getUser(widget.userId),
                    builder: (context, snapshot) {
                      User? user = snapshot.data?.data() as User?;

                      if (user == null) {
                        return const Center(
                          child: null,
                        );
                      }

                      List<PopupMenuItem> popupMenuItems = [];
                      if (widget.userId ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        popupMenuItems = [
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Ionicons.cog_outline),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Edit profile"),
                              ],
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                                "/user_profile_edit",
                                arguments: user),
                          ),
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Ionicons.log_out_outline),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Sign out"),
                              ],
                            ),
                            onTap: () => context
                                .read<FirebaseAuthService>()
                                .signOut(context: context),
                          ),
                        ];
                      }

                      return UserAvatarAndName(
                        user: user,
                        userId: widget.userId,
                        bigSize: true,
                        popupMenuItems: popupMenuItems,
                      );
                    },
                  );
                }),

            const SizedBox(
              height: 30,
            ),

            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              height: 10,
            ),

            Expanded(
              child: StreamBuilder(
                stream:
                    context.read<PostService>().getPostsOfUser(widget.userId),
                builder: (context, snapshot) {
                  List posts = snapshot.data?.docs ?? [];

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (posts.isEmpty) {
                    return const Center(
                      child: Text("It seems a bit empty here."),
                    );
                  }

                  return PostGridView(
                    posts: posts,
                    userId: widget.userId,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class PostGridView extends StatelessWidget {
  const PostGridView({
    super.key,
    required this.posts,
    required this.userId,
  });

  final List posts;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        Post post = posts[index].data();
        return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                  "/user_personal_posts",
                  arguments: {
                    "selectedPostIndex": index,
                    "userId": userId,
                  },
                ),
            child: PostPreviewTile(post: post));
      },
    );
  }
}
