// ignore_for_file: use_build_context_synchronously

import 'package:ct484_project/ui/utils/show_flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(this._auth);

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      showFlushbar(
        context: context,
        message: 'Account created successfully',
        color: Theme.of(context).primaryColor
      );
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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken!,
      );

      await _auth.signInWithCredential(credential);
      // }
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
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.accessToken != null) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      }
    } on FirebaseAuthException catch (error) {
      showFlushbar(
        context: context,
        message: error.message!,
      );
    }
  }
}
