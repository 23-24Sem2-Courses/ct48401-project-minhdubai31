import 'package:cached_network_image/cached_network_image.dart';
import 'package:ct484_project/models/comment.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/comment_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_comment_sheet.dart';
import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

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
        StreamBuilder(
          stream: context.read<UserService>().getUsers(),
          builder: (context, snapshot) {
            return FutureBuilder(
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
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            comment.content,
                            style: const TextStyle(fontSize: 15),
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
                    if(popupMenuItems.isNotEmpty) PopupMenuButton(
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
            );
          }
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
