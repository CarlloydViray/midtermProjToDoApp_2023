import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';

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
    void _deleteItem(int index) async {
      await deleteData(index);
      Navigator.pop(context);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Item deleted successfully',
          contentType: ContentType.success,
        ),
        duration: Duration(milliseconds: 2500),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    void _finishedItem(int index) async {
      await doneItem(index);
      Navigator.pop(context);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Item marked as finished',
          contentType: ContentType.success,
        ),
        duration: Duration(milliseconds: 2500),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    final userID = FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<dynamic>>(
          stream: getData(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error.toString()}'));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<dynamic> data = snapshot.data!;

            return Animate(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Animate(
                    effects: [
                      FadeEffect(),
                      SlideEffect(curve: Curves.easeIn),
                    ],
                    child: Text(
                      'Current ToDo\'s:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        int position = index + 1;
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Slidable(
                            endActionPane:
                                ActionPane(motion: ScrollMotion(), children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      confirmBtnText: 'Yes',
                                      title: 'Mark as finished?',
                                      onConfirmBtnTap: () {
                                        _finishedItem(index);
                                      });
                                },
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.done,
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      confirmBtnText: 'Delete',
                                      onConfirmBtnTap: () {
                                        _deleteItem(index);
                                      });
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ]),
                            child: SizedBox(
                              height: 85,
                              child: Animate(
                                effects: [
                                  FadeEffect(),
                                  SlideEffect(curve: Curves.easeIn),
                                ],
                                child: Card(
                                  elevation: 30,
                                  child: ListTile(
                                    title:
                                        Text(data[index]['title'].toString()),
                                    subtitle: Text("Created at: " +
                                        data[index]['date'].toString()),
                                    trailing: Icon(
                                      Icons.arrow_circle_left_rounded,
                                      color: Color(0xFF393646),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Color(0xFF393646),
                                      foregroundColor: Color(0xFFF4EEE0),
                                      child: Text(position.toString()),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Stream<List<dynamic>> getData() async* {
  final userID = FirebaseAuth.instance.currentUser!.uid;

  yield* FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .snapshots()
      .map((snapshot) => snapshot.get('todo'));
}

Future<void> deleteData(int index) async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final firestoreInstance = FirebaseFirestore.instance;
  final docRef = firestoreInstance.collection('users').doc(userID);
  final currentArray = (await docRef.get()).data()?['todo'] as List<dynamic>;

  currentArray.removeAt(index);

  await docRef.update({'todo': currentArray});
}

Future doneItem(int index) async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  DateTime dateTime = DateTime.now();
  String formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(dateTime);

  final documentReference =
      FirebaseFirestore.instance.collection('users').doc(userID);
  final snapshot = await documentReference.get();
  final data = snapshot.data();

  final myArray = data?['todo'];

  final valueAtIndex = myArray[index];
  Map<String, dynamic> finishedMap = {
    'title': valueAtIndex,
    'date': formattedDate,
  };

  await documentReference.update({
    'finished': FieldValue.arrayUnion([finishedMap]),
  });
  deleteData(index);
}
