import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/ui/widgets/custom_button.dart';
import 'package:ct484_project/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordResetScreen extends StatefulWidget {
  static String routeName = "/password_reset";
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailInputController = TextEditingController();
  bool _isLoading = false;

  void sendPasswordResetEmail() async {
    setState(() {
      _isLoading = true;
    });
    await context.read<FirebaseAuthService>().sendPasswordResetEmail(
          email: _emailInputController.text,
          context: context,
        );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Forgot your password?",
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                const Text(
                  "Enter your email address and we will send you instructions to reset your password",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                CustomTextField(
                    controller: _emailInputController,
                    hintText: "example@example.com",
                    label: "Email"),
                const SizedBox(
                    height: 15.0), // Add spacing between text and button
                CustomButton(
                  onTap: sendPasswordResetEmail,
                  text: "Send",
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 15.0),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Back to login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
