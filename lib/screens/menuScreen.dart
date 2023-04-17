import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:quickalert/quickalert.dart';

class menuScreen extends StatefulWidget {
  const menuScreen({
    super.key,
  });

  @override
  State<menuScreen> createState() => _menuScreenState();
}

class _menuScreenState extends State<menuScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff393646),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: CircleAvatar(
                backgroundColor: Color(0xFFF4EEE0),
                child: Icon(
                  Icons.person,
                  color: Color(0xFF393646),
                  size: 50,
                ),
                radius: 50,
              )),
              SizedBox(
                height: 30,
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  ZoomDrawer.of(context)!.close();
                },
                iconColor: Color(0xFFF4EEE0),
                textColor: Color(0xFFF4EEE0),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'Logout?',
                      onConfirmBtnTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                        ZoomDrawer.of(context)!.close();
                      });
                },
                iconColor: Color(0xFFF4EEE0),
                textColor: Color(0xFFF4EEE0),
              ),
            ]),
      ),
    );
  }
}
