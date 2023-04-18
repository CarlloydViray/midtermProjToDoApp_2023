import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class dummyScreen extends StatelessWidget {
  const dummyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarGlow(
              glowColor: Colors.blue,
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 100),
              endRadius: 90.0,
              child: Material(
                // Replace this child with your own
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'lib/assets/icons/1024.png',
                    height: 50,
                  ),
                  radius: 45.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
