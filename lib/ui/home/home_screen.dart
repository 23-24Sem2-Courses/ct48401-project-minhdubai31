import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Home"),
            ElevatedButton(
                onPressed: () =>
                    {context.read<FirebaseAuthService>().signOut(context: context)},
                child: Text("Sign out"))
          ],
        ),
      ),
    );
  }
}
