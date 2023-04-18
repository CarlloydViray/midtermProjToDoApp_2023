import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midtermprojecttodoapp/screens/homeScreen.dart';
import 'package:midtermprojecttodoapp/screens/loginScreen.dart';
import 'package:midtermprojecttodoapp/screens/todoScreen.dart';

class authGate extends StatelessWidget {
  const authGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loginScreen();
          }
          return HomeScreen();
        });
  }
}
