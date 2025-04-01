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

  Future<User?> signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    } finally {
      setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 85),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD5EDFF), width: 3),
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFD5EDFF),
              ),
              child: Image.asset(
                "assets/images/uthLogo.png",
                width: 170,
                height: 170,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'SmartTasks',
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "A simple and efficient to-do app",
              style: TextStyle(color: Color(0xFF3991D8), fontSize: 12),
            ),
            SizedBox(height: 80), // Giảm khoảng cách để cân đối UI
            Text(
              'Welcome',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Ready to explore? Log in to get started.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 30), // Giảm khoảng cách trước nút login
            _isSigningIn
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    User? user = await signInWithGoogle();
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Signed in as ${user.displayName}'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Color(0xFFD5EDFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 94, 26, 107),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/google_logo.png", height: 24),
                      SizedBox(width: 10),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(color: Color(0xFF130160)),
                      ),
                    ],
                  ),
                ),
            Spacer(), 
            Padding(
              padding: EdgeInsets.only(
                bottom: 20,
              ), 
              child: Row(
                mainAxisSize:
                    MainAxisSize
                        .min,
                children: [
                  Icon(
                    Icons.copyright, 
                    size: 20,
                    color: Color(0xFF4A4646),  
                  ),
                  SizedBox(width: 8), 
                  Text(
                    "UTHSmartTasks",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4646), 
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
