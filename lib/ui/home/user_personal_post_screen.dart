// ignore_for_file: must_be_immutable

import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/ui/widgets/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class UserPersonalPostScreen extends StatelessWidget {
  static const routeName = "/user_personal_posts";
  UserPersonalPostScreen({
    super.key,
    this.selectedPostIndex = 0,
  });
  int selectedPostIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your posts"),
      ),
      body: StreamBuilder(
        stream: context
            .read<PostService>()
            .getPostsOfUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          List posts = snapshot.data?.docs ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ScrollablePositionedList.builder(
            itemCount: posts.length,
            initialScrollIndex: selectedPostIndex,
            itemBuilder: (context, index) {
              Post post = posts[index].data();
              return Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  PostCard(
                    post: post,
                    postId: posts[index].id,
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
