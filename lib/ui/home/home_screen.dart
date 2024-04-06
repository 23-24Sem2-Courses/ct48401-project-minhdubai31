import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News feed'),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
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
    );
  }
}
