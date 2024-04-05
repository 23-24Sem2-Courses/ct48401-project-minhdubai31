import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/ui/widgets/custom_button.dart';
import 'package:ct484_project/ui/widgets/custom_text_field.dart';
import 'package:ct484_project/ui/widgets/oauth_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screen_welcome_header.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  bool _isEmailPasswordSignInLoading = false;
  bool _isGoogleSignInLoading = false;
  bool _isFacebookSignInLoading = false;

  void login() async {
    setState(() {
      _isEmailPasswordSignInLoading = true;
    });
    await context.read<FirebaseAuthService>().signInWithEmailPassword(
        email: _emailInputController.text,
        password: _passwordInputController.text,
        context: context);
    setState(() {
      _isEmailPasswordSignInLoading = false;
    });
  }

  void loginWithGoogle() async {
    setState(() {
      _isGoogleSignInLoading = true;
    });
    await context.read<FirebaseAuthService>().signInWithGoogle(context);
    setState(() {
      _isGoogleSignInLoading = false;
    });
  }

  void loginWithFacebook() async {
    setState(() {
      _isFacebookSignInLoading = true;
    });
    await context.read<FirebaseAuthService>().signInWithFacebook(context);
    setState(() {
      _isFacebookSignInLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const SizedBox(
                  height: 160,
                ),
                const WelcomeHeader(),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: _emailInputController,
                  hintText: "example@example.com",
                  label: "Email",
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  controller: _passwordInputController,
                  hintText: "example",
                  label: "Password",
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/password_reset');
                    },
                    child: const Text("Forgot password?"),
                  ),
                ),
                CustomButton(
                  onTap: login,
                  text: "Login",
                  isLoading: _isEmailPasswordSignInLoading,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "or",
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                OauthButton(
                  onTap: loginWithGoogle,
                  text: "Continue with Google",
                  imageAsset: 'assets/logo_google.png',
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                  borderColor: const Color.fromRGBO(0, 0, 0, 0.2),
                  overlayColor: Theme.of(context).hoverColor,
                  isLoading: _isGoogleSignInLoading,
                ),
                const SizedBox(
                  height: 5,
                ),
                OauthButton(
                  onTap: loginWithFacebook,
                  text: "Continue with Facebook",
                  imageAsset: 'assets/logo_facebook.png',
                  buttonColor: const Color(0xff0863f7),
                  textColor: Colors.white,
                  isLoading: _isFacebookSignInLoading,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 0),
                        ),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
