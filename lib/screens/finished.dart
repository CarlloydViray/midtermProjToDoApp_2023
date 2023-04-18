import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quickalert/quickalert.dart';

class finished extends StatefulWidget {
  const finished({super.key});

  @override
  State<finished> createState() => _finishedState();
}

class _finishedState extends State<finished> {
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

            return Column(
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
                    'Finished ToDo\'s:',
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
                              onPressed: (context) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    text: 'Item will be deleted Forever',
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
                            height: 80,
                            child: Animate(
                              effects: [
                                FadeEffect(),
                                SlideEffect(curve: Curves.easeIn),
                              ],
                              child: Card(
                                elevation: 30,
                                child: ListTile(
                                  title: Text(data[index]['title'].toString()),
                                  subtitle: Text("Finished at: " +
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
      .map((snapshot) => snapshot.get('finished'));
}

Future<void> deleteData(int index) async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final firestoreInstance = FirebaseFirestore.instance;
  final docRef = firestoreInstance.collection('users').doc(userID);
  final currentArray =
      (await docRef.get()).data()?['finished'] as List<dynamic>;

  currentArray.removeAt(index);

  await docRef.update({'finished': currentArray});
}
