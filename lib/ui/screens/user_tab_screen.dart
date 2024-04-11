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

class UserTabScreen extends StatelessWidget {
  const UserTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // AVATAR AND NAME
            StreamBuilder(
              stream: context.read<UserService>().getUsers(),
              builder: (context, snapshot) {
                return FutureBuilder(
                  future: context
                      .read<UserService>()
                      .getUser(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    User? user = snapshot.data?.data() as User?;
                
                    if (user == null) {
                      return const Center(
                        child: null,
                      );
                    }
                    return UserAvatarAndName(
                      user: user,
                      bigSize: true,
                      popupMenuItems: [
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
                          onTap: () => Navigator.of(context).pushNamed("/user_profile_edit", arguments: user),
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
                      ],
                    );
                  },
                );
              }
            ),

            const SizedBox(
              height: 30,
            ),

            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              height: 10,
            ),

            Expanded(
              child: StreamBuilder(
                stream: context
                    .read<PostService>()
                    .getPostsOfUser(FirebaseAuth.instance.currentUser!.uid),
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

                  return PostGridView(posts: posts);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostGridView extends StatelessWidget {
  const PostGridView({
    super.key,
    required this.posts,
  });

  final List posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: posts.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        Post post = posts[index].data();
        return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                "/user_personal_posts",
                arguments: index),
            child: PostPreviewTile(post: post));
      },
    );
  }
}
