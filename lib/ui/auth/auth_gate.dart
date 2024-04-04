import 'package:ct484_project/ui/widgets/custom_button.dart';
import 'package:ct484_project/ui/widgets/custom_text_field.dart';
import 'package:ct484_project/ui/widgets/gradient_text.dart';
import 'package:ct484_project/ui/widgets/oauth_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  String? emailError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 160,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to ",
                      style: TextStyle(fontSize: 24),
                    ),
                    GradientText(
                      "Photos Share",
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade900,
                        ],
                      ),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomTextField(
                  controller: _emailInputController,
                  hintText: "example@example.com",
                  label: "Email",
                  error: emailError,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  controller: _passwordInputController,
                  hintText: "example",
                  label: "Password",
                  error: passwordError,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(onTap: () {}, text: "Login"),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "or",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                OauthButton(
                  onTap: () {},
                  text: "Login with Google",
                  imageAsset: 'assets/logo_google.png',
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                  borderColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  overlayColor: Theme.of(context).hoverColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                OauthButton(
                  onTap: () {},
                  text: "Login with Facebook",
                  imageAsset: 'assets/logo_facebook.png',
                  buttonColor: const Color(0xff0863f7),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
