import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct484_project/models/comment.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/services/comment_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../widgets/comment_group.dart';

String calculateCommentedTime(Comment comment) {
  final postedTime = comment.createdAt.toDate();
  final now = DateTime.now();

  // Calculate the difference between now and the targetDateTime
  Duration difference = now.difference(postedTime);

  // Extract the components of the difference
  int months = difference.inDays ~/ 30;
  int days = difference.inDays % 30;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;

  // Prepare the formatted string based on the difference
  String formattedTimeDifference = '';

  if (months > 0) {
    formattedTimeDifference += '$months month${months > 1 ? 's' : ''} ';
    return formattedTimeDifference;
  } else if (days > 0) {
    formattedTimeDifference += '$days day${days > 1 ? 's' : ''} ';
  } else if (hours > 0) {
    formattedTimeDifference += '$hours hour${hours > 1 ? 's' : ''} ';
  } else if (minutes > 0) {
    formattedTimeDifference += '$minutes minute${minutes > 1 ? 's' : ''} ';
  }
  return formattedTimeDifference.isEmpty ? "Just now" : formattedTimeDifference;
}

void showCommentSheet({
  required BuildContext context,
  required Post post,
  required String postId,
}) {
  final commentInputController = TextEditingController();

  Future<void> createComment() async {
    await context.read<CommentService>().createComment(
          Comment(
              content: commentInputController.text,
              postId: postId,
              ownerUserId: FirebaseAuth.instance.currentUser!.uid,
              createdAt: Timestamp.now()),
        );
    commentInputController.clear();
  }

  showModalBottomSheet(
    showDragHandle: true,
    useRootNavigator: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.92,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: context
                        .read<CommentService>()
                        .getCommentsOfPost(postId),
                    builder: (context, snapshot) {
                      List comments = snapshot.data?.docs ?? [];

                      if (comments.isEmpty) {
                        return const Center(child: Text("Be the first to comment on this post"));
                      }

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          Comment comment = comments[index].data();
                          return CommentGroup(
                            comment: comment,
                            commentId: comments[index].id,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: commentInputController,
                  onSubmitted: (text) async {
                    await createComment();
                  },
                  style: const TextStyle(fontSize: 15),
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      filled: true,
                      fillColor: const Color(0xfff2f2f6),
                      hintText: "Add a comment",
                      hintStyle:
                          const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4)),
                      floatingLabelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await createComment();
                        },
                        icon: const Icon(Ionicons.send),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
