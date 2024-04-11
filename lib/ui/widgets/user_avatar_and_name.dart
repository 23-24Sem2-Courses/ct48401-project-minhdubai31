// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ct484_project/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class UserAvatarAndName extends StatefulWidget {
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
  State<UserAvatarAndName> createState() => _UserAvatarAndNameState();
}

class _UserAvatarAndNameState extends State<UserAvatarAndName> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ImageProvider avatar = const AssetImage('assets/avatar.png');

    if (widget.user.avatarUrl != "") {
      avatar = CachedNetworkImageProvider(widget.user.avatarUrl);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: widget.bigSize

          // FOR USER TAB
          ? Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: UserPopupMenu(popupMenuItems: widget.popupMenuItems),
                ),
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
                  widget.user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(
                  height: 4,
                ),
                widget.user.biography == ""
                    ? GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed("/user_profile_edit", arguments: widget.user),
                        child: Text(
                          "Add biography",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                          widget.user.biography,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ),
              ],
            )

          // FOR HOME TAB
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
                      height: 45,
                    ),
                    widget.time != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              Text(
                                widget.time!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              )
                            ],
                          )
                        : Text(
                            widget.user.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          )
                  ],
                ),
                // POP UP MENU
                if (widget.popupMenuItems.isNotEmpty)
                  UserPopupMenu(popupMenuItems: widget.popupMenuItems),
              ],
            ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
