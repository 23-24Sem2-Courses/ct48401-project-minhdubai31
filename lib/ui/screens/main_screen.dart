import 'package:ct484_project/ui/screens/user_tab_screen.dart';
import 'package:ct484_project/ui/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'home_tab_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
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
        children: const [
          HomeTabScreen(),
          UserTabScreen()
        ],
      ),
    );
  }
}
