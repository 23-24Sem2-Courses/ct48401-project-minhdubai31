
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

class BottomNavigation extends StatefulWidget {
  final TabController tabController;
  const BottomNavigation({
    super.key,
    required this.tabController,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  @override
  // UPDATE BOTTOM NAVIGATION BAR INDEX ON TAB BAR VIEW SWIPE
  void initState() {
    super.initState();

    widget.tabController.animation?.addListener(() {
      setState(() {
        // IF USER SWIPE MORE THAN HALF THEN UPDATE THE CURRENT INDEX (UPDATE FASTER)
        int indexChange = widget.tabController.offset.round();
        int index = widget.tabController.index + indexChange;
        _currentIndex = index == 1 ? 2 : index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: _currentIndex == 0
                ? const Icon(Ionicons.home)
                : const Icon(Ionicons.home_outline),
          ),
          label: "Home",
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Ionicons.add_circle_outline,
            size: 40,
          ),
          label: "Create new post",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: _currentIndex == 2
                ? const Icon(Ionicons.person)
                : const Icon(Ionicons.person_outline),
          ),
          label: "User",
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedFontSize: 8,
      selectedFontSize: 8,
      currentIndex: _currentIndex,
      onTap: (index) async {
        setState(() {
          _currentIndex = index != 1 ? index : _currentIndex;
        });

        // CREATE A NEW POST
        if (index == 1) {
          final XFile? selectedImage =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (selectedImage != null) {
            Navigator.of(context).pushNamed(
              "/new_post_screen",
              arguments: selectedImage,
            );
          }
        } else {
          widget.tabController.animateTo(index == 2 ? 1 : index);
        }
      },
    );
  }
}
