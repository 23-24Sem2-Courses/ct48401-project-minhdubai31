// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ct484_project/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserAvatarAndName extends StatelessWidget {
  UserAvatarAndName({
    super.key,
    required this.user,
    this.popupMenuItems = const [],
    this.bigSize = false,
    this.time,
  });

  final User user;
  bool bigSize;
  List<PopupMenuItem> popupMenuItems;
  String? time;

  @override
  Widget build(BuildContext context) {
    ImageProvider avatar = const AssetImage('assets/avatar.png');

    if (user.avatarUrl != "") {
      avatar = CachedNetworkImageProvider(user.avatarUrl);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: bigSize
          ? Column(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: UserPopupMenu(popupMenuItems: popupMenuItems)),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black26,
                  child: CircleAvatar(
                    backgroundImage: avatar,
                    radius: 38,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: CircleAvatar(backgroundImage: avatar),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    time != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              Text(
                                time!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              )
                            ],
                          )
                        : Text(
                            user.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          )
                  ],
                ),
                // POP UP MENU
                UserPopupMenu(popupMenuItems: popupMenuItems)
              ],
            ),
    );
  }
}

class UserPopupMenu extends StatelessWidget {
  const UserPopupMenu({
    super.key,
    required this.popupMenuItems,
  });

  final List<PopupMenuItem> popupMenuItems;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => popupMenuItems,
      icon: const Icon(Ionicons.ellipsis_horizontal_outline),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: Colors.black12,
            width: 0.5,
          )),
      color: Colors.white,
      surfaceTintColor: Colors.white,
    );
  }
}
