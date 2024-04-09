// ignore_for_file: use_build_context_synchronously

import 'package:ct484_project/models/user.dart';
import 'package:ct484_project/services/user_service.dart';
import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> createUserDatabaseIfNewUser(UserCredential userCredential, [String? name, String? email]) async {
  if (userCredential.user != null) {
    bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
    final userDetails = userCredential.additionalUserInfo!.profile;
    final providerId = userCredential.additionalUserInfo?.providerId;

    String avatar = "";
    switch(providerId) {
      case "facebook.com": avatar = userDetails?["picture"]["data"]["url"];
      case "google.com": avatar = userDetails?["picture"];
    }

    if (isNewUser) {
      UserService().addUser(
        User(
          name: name ?? userDetails?["name"],
          email: email ?? userDetails?["email"],
          avatarUrl: avatar,
          postsId: [],
        ),
        userCredential.user!.uid
      );
    }
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(this._auth);

  Future<void> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      createUserDatabaseIfNewUser(userCredential, name, email);

      showFlushbar(
          context: context,
          message: 'Account created successfully',
          color: Theme.of(context).primaryColor);

      // Auto sign in and go back to Home screen
      await signInWithEmailPassword(
          email: email, password: password, context: context);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      showFlushbar(
        context: context,
        message: e.message!,
      );
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      FocusScope.of(context).unfocus();
    } on FirebaseAuthException catch (error) {
      showFlushbar(
        context: context,
        message: error.message!,
      );
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      // TO MAKE SURE SHOW SELECT USER WHILE LOGIN WITH GOOGLE
      if (_auth.currentUser?.providerData[0].providerId == 'google.com') {
        await GoogleSignIn().disconnect();
      }

      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      showFlushbar(
        context: context,
        message: error.message!,
      );
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      FocusScope.of(context).unfocus();
      showFlushbar(
        context: context,
        message: 'Email sent',
        color: Theme.of(context).colorScheme.primary,
      );
    } on FirebaseAuthException catch (error) {
      showFlushbar(
        context: context,
        message: error.message!,
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken!,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        createUserDatabaseIfNewUser(userCredential);

        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (error) {
      showFlushbar(
        context: context,
        message: error.message!,
      );
    } on PlatformException catch (error) {
      showFlushbar(
        context: context,
        message: error.message!,
      );
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();

      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.accessToken != null) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        final UserCredential userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);

        createUserDatabaseIfNewUser(userCredential);
        print(userCredential);


        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (error) {
      showFlushbar(
        context: context,
        message: error.message!,
      );
    }
  }
}
