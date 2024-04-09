import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Color.fromRGBO(220, 220, 220, 1)))),
        child: BottomNavigation(
          tabController: _tabController!,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const HomePage(),
          ElevatedButton(
            onPressed: () {
              context.read<FirebaseAuthService>().signOut(context: context);
            },
            child: const Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
