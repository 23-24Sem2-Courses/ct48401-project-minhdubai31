import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/firebase_storage_service.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:ct484_project/ui/widgets/custom_button.dart';
import 'package:ct484_project/ui/widgets/user_avatar_and_name.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateNewPostScreen extends StatefulWidget {
  static const String routeName = "/new_post_screen";
  const CreateNewPostScreen({super.key});

  @override
  State<CreateNewPostScreen> createState() => _CreateNewPostScreenState();
}

class _CreateNewPostScreenState extends State<CreateNewPostScreen> {
  final _captionInputController = TextEditingController();

  bool isUploading = false;

  void createPost(XFile imageFile) async {
    String caption = _captionInputController.text;
    if (caption.isEmpty) {
      showFlushbar(context: context, message: "Please enter a caption");
      return;
    }

    setState(() {
      isUploading = true;
    });

    String uploadedImageUrl =
        await context.read<FirebaseStorageService>().uploadPostImage(imageFile);
    await context.read<PostService>().createPost(
          Post(
            ownerUserId: FirebaseAuth.instance.currentUser!.uid,
            caption: caption,
            totalLike: 0,
            imageUrl: uploadedImageUrl,
            likesUserIdList: [],
            createdAt: Timestamp.now(),
          ),
        );

    setState(() {
      isUploading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final imageXFile = ModalRoute.of(context)!.settings.arguments as XFile;
    final bool isKeyboardClose =
        MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
      ),
      floatingActionButton: Visibility(
        visible: isKeyboardClose,
        maintainAnimation: true,
        maintainState: true,
        child: AnimatedSlide(
          offset: isKeyboardClose ? const Offset(0, 0) : const Offset(0, 1.5),
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          child: CustomButton(
            onTap: () => createPost(imageXFile),
            text: "Share",
            isLoading: isUploading,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: null,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: false,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // AVATAR AND NAME
              FutureBuilder(
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
                    return UserAvatarAndName(user: user);
                  }),
              const SizedBox(
                height: 8,
              ),
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Image.file(
                  File(imageXFile.path),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _captionInputController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write a caption...",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
