import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:midtermprojecttodoapp/authGate.dart';
import 'package:midtermprojecttodoapp/screens/menuScreen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZoomDrawer(
        menuBackgroundColor: Color(0xff393646),
        controller: zoomDrawerController,
        menuScreen: const menuScreen(),
        mainScreen: const authGate(),
        clipMainScreen: false,
        showShadow: true,
        shadowLayer1Color: Color(0xff4F4557),
        shadowLayer2Color: Color(0xff6D5D6E),
        style: DrawerStyle.defaultStyle,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
      ),
    );
  }
}
