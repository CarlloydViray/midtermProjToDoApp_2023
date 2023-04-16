import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterfire_ui/auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class todoScreen extends StatefulWidget {
  const todoScreen({super.key});

  @override
  State<todoScreen> createState() => _todoScreenState();
}

class _todoScreenState extends State<todoScreen> {

int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: getAllDataFromFirestoreArray(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<dynamic> data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(data[index].toString()),
                    trailing: Icon(Icons.done),
                  ),
                ),
              );
            },
          );
        },
      ),
    ));
  }
}

Future<List<dynamic>> getAllDataFromFirestoreArray() async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  List<dynamic> arrayData = [];

  try {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();

    arrayData = documentSnapshot.get('todo');
  } catch (e) {
    print(e.toString());
  }

  return arrayData;
}


// await documentReference.update({
//   'array_field_name': FieldValue.arrayRemove([item_to_remove]),
// });