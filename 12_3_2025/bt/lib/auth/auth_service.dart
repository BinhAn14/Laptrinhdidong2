import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginwithGoogle() async {
    try {
      if (kIsWeb) {
        // Cho Flutter Web
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(authProvider);
      } else {
        // Cho Android & iOS
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null; // Người dùng hủy đăng nhập

        final googleAuth = await googleUser.authentication;
        final cred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        return await _auth.signInWithCredential(cred);
      }
    } catch (e) {
      log("Error during Google Sign-In: $e");
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong: $e");
    }
  }
}
