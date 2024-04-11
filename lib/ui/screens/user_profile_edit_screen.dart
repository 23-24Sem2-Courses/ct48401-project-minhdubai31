// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/firebase_storage_service.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:ct484_project/ui/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class UserProfileEditScreen extends StatefulWidget {
  static const routeName = "/user_profile_edit";
  const UserProfileEditScreen({
    super.key,
    required this.updateUser,
  });

  final User updateUser;

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  final nameInputController = TextEditingController();
  final biographyEditingController = TextEditingController();
  XFile? selectedImage;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    nameInputController.text = widget.updateUser.name;
    biographyEditingController.text = widget.updateUser.biography;
  }

  Map<String, String>? uploadedImage;
  void updateUser() async {
    setState(() {
      isUploading = true;
    });

    // IF AVATAR CHANGE => UPLOAD NEW FILE
    if (selectedImage != null) {
      uploadedImage = await context
          .read<FirebaseStorageService>()
          .uploadPostImage(selectedImage!);

      // IF CURRENT AVATAR IMAGE FILE EXISTS IN FIREBASE STORAGE => DELETE
      if (widget.updateUser.avatarFileName.isNotEmpty) {
        await context
            .read<FirebaseStorageService>()
            .deleteImage(widget.updateUser.avatarFileName);
      }

      await context.read<UserService>().updateUser(
            FirebaseAuth.instance.currentUser!.uid,
            widget.updateUser.copyWith(
              name: nameInputController.text,
              biography: biographyEditingController.text,
              avatarUrl: uploadedImage!["url"],
              avatarFileName: uploadedImage!["name"],
            ),
          );
    } else {
      await context.read<UserService>().updateUser(
            FirebaseAuth.instance.currentUser!.uid,
            widget.updateUser.copyWith(
              name: nameInputController.text,
              biography: biographyEditingController.text,
            ),
          );
    }

    Navigator.of(context).pop();
    showFlushbar(
      context: context,
      message: "Your profile was updated",
      color: Theme.of(context).primaryColor,
    );

    setState(() {
      isUploading = false;
    });
  }

  void selectNewImage() async {
    XFile? newImageXFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = newImageXFile ?? selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Edit Profile"),
            IconButton(
              onPressed: updateUser,
              icon: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Ionicons.save_outline),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.black26,
                    child: selectedImage != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(
                              File(selectedImage!.path),
                            ),
                            radius: 68,
                          )
                        : widget.updateUser.avatarUrl.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.updateUser.avatarUrl,
                                ),
                                radius: 68,
                              )
                            : const CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/avatar.png",
                                ),
                                radius: 68,
                              ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      onPressed: selectNewImage,
                      icon: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        child: const Icon(Ionicons.swap_horizontal_outline),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                controller: nameInputController,
                hintText: "Alloy",
                label: "Name",
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextField(
                controller: biographyEditingController,
                hintText: "Tell everyone something about you",
                label: "Biography",
                maxLines: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
