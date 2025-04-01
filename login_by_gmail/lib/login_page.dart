import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;
  String? loginTitle;
  String? loginMessage;

  Future<User?> signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        displayStatusLogin(
          "Google Sign-In Failed",
          "User canceled the Google sign-in process.",
        );
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      displayStatusLogin(
        "Success!\n Hi ${userCredential.user!.email}",
        "Wellcome to UTHSmartTasks",
      );
      return userCredential.user;
    } catch (e) {
      displayStatusLogin("Error", "Login failed. Try again.");
      return null;
    } finally {
      setState(() => _isSigningIn = false);
    }
  }

  /// 🟢 Cập nhật trạng thái để hiển thị thông báo trên UI
  void displayStatusLogin(String title, String message) {
    setState(() {
      loginTitle = title;
      loginMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isSigningIn
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    await signInWithGoogle();
                  },
                  child: Text(
                    "Login by Gmail",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),

                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                    backgroundColor: Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 94, 26, 107),
                      ),
                    ),
                  ),
                ),

            /// 🟡 Nếu có thông báo, hiển thị Container bên dưới nút login
            if (loginTitle != null && loginMessage != null)
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: loginTitle == "Google Sign-In Failed" ? Colors.red[100] : Colors.cyan[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        loginTitle!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(loginMessage!, style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
