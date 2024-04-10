import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct484_project/models/comment.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/comment_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

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
                  style: const TextStyle(fontSize: 16),
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

class CommentGroup extends StatelessWidget {
  const CommentGroup({
    super.key,
    required this.comment,
    required this.commentId,
  });

  final Comment comment;
  final String commentId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        FutureBuilder(
          future: context.read<UserService>().getUser(comment.ownerUserId),
          builder: (context, snapshot) {
            User? user = snapshot.data?.data() as User?;

            if (user == null) {
              return const Center(
                child: null,
              );
            }

            ImageProvider avatar = const AssetImage('assets/avatar.png');

            if (user.avatarUrl != "") {
              avatar = CachedNetworkImageProvider(user.avatarUrl);
            }

            List<PopupMenuItem> popupMenuItems = [];
            if (FirebaseAuth.instance.currentUser!.uid == comment.ownerUserId) {
              popupMenuItems = [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Ionicons.trash_bin_outline),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Delete this comment"),
                    ],
                  ),
                  onTap: () {
                    context.read<CommentService>().deleteComment(commentId);
                    showFlushbar(
                        context: context,
                        message: "Comment was deleted successfully",
                        color: Theme.of(context).primaryColor);
                  },
                ),
              ];
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: CircleAvatar(backgroundImage: avatar),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        comment.content,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        calculateCommentedTime(comment),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                      )
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => popupMenuItems,
                  icon: const Icon(Ionicons.ellipsis_vertical_outline),
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: Colors.black12,
                        width: 0.5,
                      )),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                )
              ],
            );
          },
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
