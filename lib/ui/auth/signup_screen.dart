import 'package:ct484_project/services/firebase_auth_service.dart';
import 'package:ct484_project/ui/auth/auth_screen_welcome_header.dart';
import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:ct484_project/ui/widgets/custom_button.dart';
import 'package:ct484_project/ui/widgets/custom_text_field.dart';
import 'package:ct484_project/ui/widgets/oauth_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/signup";
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameInputController = TextEditingController();
  final _emailInputController = TextEditingController();
  final _passwordInputController = TextEditingController();
  final _passwordConfirmInputController = TextEditingController();

  bool _isEmailPasswordSignUpLoading = false;
  bool _isGoogleSignInLoading = false;
  bool _isFacebookSignInLoading = false;

  void signUp() async {
    setState(() {
      _isEmailPasswordSignUpLoading = true;
    });

    if (_passwordInputController.text != _passwordConfirmInputController.text) {
      showFlushbar(context: context, message: "Passwords do not match");
    } else {
      await context.read<FirebaseAuthService>().signUpWithEmailPassword(
            name: _nameInputController.text,
            email: _emailInputController.text,
            password: _passwordInputController.text,
            context: context,
          );
    }

    setState(() {
      _isEmailPasswordSignUpLoading = false;
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
    return Opacity(
      opacity: _isGoogleSignInLoading || _isFacebookSignInLoading ? 0.8 : 1,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                const SizedBox(
                  height: 8,
                ),
                const WelcomeHeader(),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: _nameInputController,
                  hintText: "Alloy",
                  label: "Name",
                ),
                const SizedBox(
                  height: 8,
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
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  controller: _passwordConfirmInputController,
                  hintText: "example",
                  label: "Confirm password",
                  obscureText: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  child: CustomButton(
                    onTap: signUp,
                    text: "Sign up",
                    isLoading: _isEmailPasswordSignUpLoading,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "or",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  child: OauthButton(
                    onTap: loginWithGoogle,
                    text: "Continue with Google",
                    imageAsset: 'assets/logo_google.png',
                    buttonColor: Colors.white,
                    textColor: Colors.black,
                    borderColor: const Color.fromRGBO(0, 0, 0, 0.2),
                    overlayColor: Theme.of(context).hoverColor,
                    isLoading: _isGoogleSignInLoading,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  child: OauthButton(
                    onTap: loginWithFacebook,
                    text: "Continue with Facebook",
                    imageAsset: 'assets/logo_facebook.png',
                    buttonColor: const Color(0xff0863f7),
                    textColor: Colors.white,
                    isLoading: _isFacebookSignInLoading,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 0),
                        ),
                      ),
                      child: const Text(
                        "Sign in",
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
