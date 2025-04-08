import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  AppUser? _user;
  bool _isSigningIn = false;
  String? _loginTitle;
  String? _loginMessage;

  AppUser? get user => _user;
  bool get isSigningIn => _isSigningIn;
  String? get loginTitle => _loginTitle;
  String? get loginMessage => _loginMessage;

  Future<void> signInWithGoogle() async {
    _isSigningIn = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _setLoginStatus(
          "Google Sign-In Failed",
          "User canceled the Google sign-in process.",
        );
        _isSigningIn = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      _user = AppUser.fromFirebaseUser(userCredential.user);
      _setLoginStatus(
        "Success!\nHi ${userCredential.user!.email}",
        "Welcome to UTHSmartTasks",
      );
    } catch (e) {
      _setLoginStatus("Error", "Login failed. Try again.");
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  void _setLoginStatus(String title, String message) {
    _loginTitle = title;
    _loginMessage = message;
  }

  void clearLoginStatus() {
    _loginTitle = null;
    _loginMessage = null;
    notifyListeners();
  }
}