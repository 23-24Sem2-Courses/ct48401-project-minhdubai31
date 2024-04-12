// ignore_for_file: must_be_immutable

import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/ui/widgets/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class UserPersonalPostScreen extends StatefulWidget {
  static const routeName = "/user_personal_posts";
  UserPersonalPostScreen({
    super.key,
    this.selectedPostIndex = 0, required this.userId,
  });
  int selectedPostIndex;
  final String userId;

  @override
  State<UserPersonalPostScreen> createState() => _UserPersonalPostScreenState();
}

class _UserPersonalPostScreenState extends State<UserPersonalPostScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.userId == FirebaseAuth.instance.currentUser!.uid ? const Text("Your posts") : const Text("Posts"),
      ),
      body: StreamBuilder(
        stream: context
            .read<PostService>()
            .getPostsOfUser(widget.userId),
        builder: (context, snapshot) {
          List posts = snapshot.data?.docs ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ScrollablePositionedList.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            initialScrollIndex: widget.selectedPostIndex,
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
