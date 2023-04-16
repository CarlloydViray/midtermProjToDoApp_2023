import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quickalert/quickalert.dart';

class toCreate extends StatefulWidget {
  const toCreate({super.key});

  @override
  State<toCreate> createState() => _toCreateState();
}

class _toCreateState extends State<toCreate> {
  var todoTextController = TextEditingController();

  void addItem() async {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
            ),
            TextField(
              
              controller: todoTextController,
              
              decoration: InputDecoration(
                labelText: 'Add to-do item',
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),

                ),
                filled: true,
                fillColor: Colors.white,
                
              ),
            ),
            
            SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: addItem,
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFF393646),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18))),
              child: const Text('Add to to-do list'),
            ),
          ],
        ),
      ),
    );
  }
}
