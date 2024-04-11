// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ct484_project/models/post.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/firebase_storage_service.dart';
import 'package:ct484_project/services/post_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:ct484_project/ui/widgets/user_avatar_and_name.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CreateEditPostScreen extends StatefulWidget {
  static const String routeName = "/create_edit_post_screen";
  CreateEditPostScreen({super.key, this.imageXFile, this.post, this.postId});
  Post? post;
  String? postId;
  XFile? imageXFile;

  @override
  State<CreateEditPostScreen> createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen>
    with AutomaticKeepAliveClientMixin {
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

    Map<String, String> uploadedImage =
        await context.read<FirebaseStorageService>().uploadPostImage(imageFile);

    await context.read<PostService>().createPost(
          Post(
            ownerUserId: FirebaseAuth.instance.currentUser!.uid,
            caption: caption,
            totalLike: 0,
            imageUrl: uploadedImage["url"]!,
            imageFileName: uploadedImage["name"]!,
            likesUserIdList: [],
            createdAt: Timestamp.now(),
          ),
        );

    setState(() {
      isUploading = false;
    });
    Navigator.of(context).pop();
  }

  void updatePost(XFile? imageFile, Post post, String postId) async {
    String caption = _captionInputController.text;
    if (caption.isEmpty) {
      showFlushbar(context: context, message: "Please enter a caption");
      return;
    }

    setState(() {
      isUploading = true;
    });

    Map<String, String>? uploadedImage;

    if (imageFile != null) {
      uploadedImage = await context
          .read<FirebaseStorageService>()
          .uploadPostImage(imageFile);
      await context
          .read<FirebaseStorageService>()
          .deleteImage(post.imageFileName);
      await context.read<PostService>().updatePost(
            postId,
            post.copyWith(
              caption: caption,
              imageUrl: uploadedImage["url"],
              imageFileName: uploadedImage["name"],
            ),
          );
    } else {
      await context.read<PostService>().updatePost(
            postId,
            post.copyWith(
              caption: caption,
            ),
          );
    }

    setState(() {
      isUploading = false;
    });
    Navigator.of(context).pop();
  }

  void selectNewImage() async {
    XFile? newImageXFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      widget.imageXFile = newImageXFile ?? widget.imageXFile;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _captionInputController.text = widget.post!.caption;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.post != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Edit Post"),
                  IconButton(
                    onPressed: () => updatePost(
                        widget.imageXFile, widget.post!, widget.postId!),
                    icon: isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Ionicons.save_outline),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Create New Post'),
                  IconButton(
                    onPressed: () => createPost(widget.imageXFile!),
                    icon: isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Icon(Ionicons.create_outline),
                  )
                ],
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: false,
          physics: const AlwaysScrollableScrollPhysics(),
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
                      return UserAvatarAndName(user: user);
                    },
                  );
                }
              ),
              const SizedBox(
                height: 8,
              ),
              Stack(
                children: [
                  GestureDetector(
                    onDoubleTap: selectNewImage,
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      // IF imageXFile == NULL => UPDATE => SHOW THE CURRENT IMAGE OF THE POST
                      child: widget.imageXFile == null
                          ? CachedNetworkImage(
                              imageUrl: widget.post!.imageUrl,
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
                            )
                          // ELSE => CREATE NEW => SHOW SELECTED IMAGE
                          : Image.file(
                              File(widget.imageXFile!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      onPressed: selectNewImage,
                      icon: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: const Icon(Ionicons.swap_horizontal_outline),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _captionInputController,
                  maxLines: 5,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
