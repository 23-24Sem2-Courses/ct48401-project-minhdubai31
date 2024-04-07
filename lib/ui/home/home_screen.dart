import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/ui/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(),
      // CHANGE THE COLOR OF STATUS BAR
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 0, 24),
                child: GradientText(
                  "Photos Share",
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400,
                      Colors.blue.shade800,
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const PostCard(),
              const SizedBox(
                height: 30,
              ),
              const PostCard(),
              ElevatedButton(
                  onPressed: () => {
                        context
                            .read<FirebaseAuthService>()
                            .signOut(context: context)
                      },
                  child: Text("Sign out"))
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    super.key,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            child: _activeTab == 0
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
            child: _activeTab == 2
                ? const Icon(Ionicons.person)
                : const Icon(Ionicons.person_outline),
          ),
          label: "User",
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _activeTab,
      onTap: (index) {
        setState(() {
          _activeTab = index != 1 ? index : _activeTab;
        });

        if (index == 1) {
          ImagePicker().pickImage(source: ImageSource.gallery);
        }
      },
    );
  }
}
