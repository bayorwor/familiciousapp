import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void logout() {
    _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TextButton(
          child: Row(
            children: const [
              Icon(UniconsLine.sign_out_alt),
              Text("logout"),
            ],
          ),
          onPressed: () => logout(),
        ),
      ),
    );
  }
}
