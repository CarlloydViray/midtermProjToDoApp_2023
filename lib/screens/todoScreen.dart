import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterfire_ui/auth.dart';

class todoScreen extends StatefulWidget {
  const todoScreen({super.key});

  @override
  State<todoScreen> createState() => _todoScreenState();
}

class _todoScreenState extends State<todoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ToDo Application'),
          actions: [
            SignOutButton()
          ],
        ),
        body: Column(
          children: [Text("data")],
        ),
      ),
    );
  }
}
