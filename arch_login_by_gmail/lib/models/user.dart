import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String? email;
  final String? uid;

  AppUser({this.email, this.uid});

  factory AppUser.fromFirebaseUser(User? user) {
    if (user == null) return AppUser();
    return AppUser(email: user.email, uid: user.uid);
  }
}