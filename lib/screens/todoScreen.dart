import 'package:cloud_firestore/cloud_firestore.dart';
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
        // body: ElevatedButton(onPressed: (){
        //   print(getAllDataFromFirestoreArray.toString());
        // }, child: Text('DEBUG')),
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
              return GestureDetector(
                onTap: () {
                  return;
                },
                child: ListTile(
                  title: Text(data[index].toString()),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}


Future<List<dynamic>> getAllDataFromFirestoreArray() async {
  List<dynamic> data = [];

  try {
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();

    querySnapshot.docs.forEach((doc) {
      data.addAll(doc.get('arrayFieldName'));
    });
  } catch (e) {
    print(e.toString());
  }

  return data;
}