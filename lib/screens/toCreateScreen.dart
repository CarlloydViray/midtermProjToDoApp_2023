import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quickalert/quickalert.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class toCreate extends StatefulWidget {
  const toCreate({super.key});

  @override
  State<toCreate> createState() => _toCreateState();
}

class _toCreateState extends State<toCreate> {
  var todoTextController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  void addItem() async {
    if (_formkey.currentState!.validate()) {
      final userID = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(userID);
      await documentReference.update({
        'todo': FieldValue.arrayUnion([todoTextController.text]),
      });
      todoTextController.clear();
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Item added successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            Image(
              image: AssetImage('lib/assets/icons/1024.png'),
              height: 150, // set height to 200 pixels
              width: 150,
            ),
            SizedBox(
              height: 50,
            ),
            Form(
              key: _formkey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Required. Please enter an item';
                  }
                },
                controller: todoTextController,
                decoration: InputDecoration(
                  labelText: 'Add toDo item',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addItem();
                  FocusScope.of(context).unfocus();
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFF393646),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18))),
              child: const Text('Add to ToDo list'),
            ),
          ],
        ),
      ),
    );
  }
}
