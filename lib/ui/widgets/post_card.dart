import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/comment_service.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_comment_sheet.dart';
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
  bool showHeart = false;

  // ADD OR REMOVE USER ID FROM likesUserIdList
  void toggleLike() {
    if (widget.post.likesUserIdList
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      widget.post.likesUserIdList
          .remove(FirebaseAuth.instance.currentUser!.uid);
    } else {
      widget.post.likesUserIdList.add(FirebaseAuth.instance.currentUser!.uid);
    }
    context.read<PostService>().updatePost(widget.postId, widget.post);
  }

  // ADD OR REMOVE USER ID FROM likesUserIdList
  void likePost() {
    setState(() {
      showHeart = true;
    });

    if (widget.post.likesUserIdList
            .contains(FirebaseAuth.instance.currentUser!.uid) ==
        false) {
      widget.post.likesUserIdList.add(FirebaseAuth.instance.currentUser!.uid);
    }
    context.read<PostService>().updatePost(widget.postId, widget.post);

    Timer(const Duration(seconds: 1), () {
      setState(() {
        showHeart = false;
      });
    });
  }

  String calculatePostedTime() {
    final postedTime = widget.post.createdAt.toDate();
    final now = DateTime.now();

    // Calculate the difference between now and the target DateTime
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
    return formattedTimeDifference.isEmpty
        ? "Just now"
        : formattedTimeDifference;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final UserService userService = UserService();
    return StreamBuilder(
      stream: context.read<UserService>().getUsers(),
      builder: (context, snapshot) {
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
                        context
                            .read<PostService>()
                            .deletePost(widget.postId, widget.post);
                      },
                    );
                  },
                ),
              ];
            }
        
            final post = widget.post;
            final postId = widget.postId;
            final likesUserIdList = post.likesUserIdList;
            final likesCount = likesUserIdList.length;
        
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AVATAR AND NAME
                UserAvatarAndName(
                  user: user,
                  popupMenuItems: popupMenuItems,
                  time: calculatePostedTime(),
                ),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onDoubleTap: likePost,
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 5,
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Positioned.fill(
                        child: AnimatedScale(
                          scale: showHeart ? 1.0 : 0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 150),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Ionicons.heart,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                                  onTap: toggleLike,
                                  child: likesUserIdList.contains(
                                          FirebaseAuth.instance.currentUser!.uid)
                                      ? Icon(
                                          Ionicons.heart,
                                          size: 30,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : const Icon(
                                          Ionicons.heart_outline,
                                          size: 30,
                                        ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showCommentSheet(
                                        context: context,
                                        post: post,
                                        postId: postId);
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
                            child: Text(
                              likesUserIdList.isEmpty
                                  ? ""
                                  : "$likesCount like${likesCount > 1 ? 's' : ''}",
                              style: const TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  fontSize: 13),
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
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            post.caption,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      GestureDetector(
                        onTap: () {
                          showCommentSheet(
                              context: context, post: post, postId: postId);
                        },
                        child: StreamBuilder(
                            stream: context
                                .read<CommentService>()
                                .getCommentsOfPost(postId),
                            builder: (context, snapshot) {
                              List comments = snapshot.data?.docs ?? [];
                              return Text(
                                "View ${comments.isEmpty ? '' : "all ${comments.length} "}comment${comments.length > 1 ? 's' : ''}",
                                style: const TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 0.4),
                                    fontSize: 14),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
