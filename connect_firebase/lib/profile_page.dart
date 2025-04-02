import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; 

final GoogleSignIn googleSignIn = GoogleSignIn();
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final googleUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            width: 45,
            height: 45,
            padding: EdgeInsets.only(left: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (googleUser?.photoURL != null)
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(googleUser!.photoURL!),
                radius: 50,
              ),
            )
          else
            Center(child: const Icon(Icons.account_circle, size: 100)),

          const SizedBox(height: 20),

          // Name
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text("Name", style: TextStyle(fontSize: 16)),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                googleUser?.displayName ?? 'No Name',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Email
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text("Email", style: TextStyle(fontSize: 16)),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                googleUser?.email ?? 'No Email',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Date of Birth
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text(
              "Date of Birth",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter, // Căn giữa
        child: Container(
          margin: const EdgeInsets.only(left: 30, bottom: 10),
          width: 300, // Kích thước chiều rộng
          // height: 40, // Kích thước chiều cao
          decoration: BoxDecoration(
            color: Colors.blue, // Màu nền
            borderRadius: BorderRadius.circular(25), // Bo góc
          ),
          child: TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              await googleSignIn.signOut();
              Navigator.pop(context); 
            },
            child: const Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
