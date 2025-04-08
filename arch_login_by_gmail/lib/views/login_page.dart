import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!viewModel.isSigningIn && viewModel.loginTitle == null)
                  Image(
                    image: AssetImage("assets/images/mvvm.png"),
                    height: 200,
                    width: 200,
                  ),
                
                viewModel.isSigningIn
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () async {
                        await viewModel.signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 90,
                          vertical: 15,
                        ),
                        backgroundColor: Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 94, 26, 107),
                          ),
                        ),
                      ),
                      child: Text(
                        "Login by Gmail",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                if (viewModel.loginTitle != null &&
                    viewModel.loginMessage != null)
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 30,
                        left: 15,
                        right: 15,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            viewModel.loginTitle == "Google Sign-In Failed"
                                ? Colors.red[100]
                                : Colors.cyan[100],
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
                            viewModel.loginTitle!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            viewModel.loginMessage!,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
