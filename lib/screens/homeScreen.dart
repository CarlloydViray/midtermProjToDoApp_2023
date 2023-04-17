import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:midtermprojecttodoapp/screens/finished.dart';
import 'package:midtermprojecttodoapp/screens/toCreateScreen.dart';
import 'package:midtermprojecttodoapp/screens/todoScreen.dart';
import 'package:quickalert/quickalert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Text('ToDo Application', style: TextStyle(fontSize: 25),),
          centerTitle: true,
          leading: IconButton(onPressed: (){
            QuickAlert.show(context: context, type: QuickAlertType.confirm, title: 'Logout?', onConfirmBtnTap: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            });
          }, icon: Icon(Icons.logout))
        
        ),
      ),
      body: getSelectedIndex(index: selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        items: [
          Icon(
            Icons.checklist,
            color: Color(0xFFF4EEE0),
            size: 25,
          ),
          Icon(
            Icons.add,
            color: Color(0xFFF4EEE0),
            size: 25,
          ),
          Icon(
            Icons.done,
            color: Color(0xFFF4EEE0),
            size: 25,
          )
        ],
        color: Color(0xFF393646),
        backgroundColor: Color(0xFFF4EEE0),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    ));
  }
}


Widget getSelectedIndex({required int index}){
  Widget widget = Container();
  switch(index){
    case 0:
    widget = const todoScreen();
    break;
    case 1:
    widget = const toCreate();
    break;
    case 2:
    widget = const finished();
    break;
  }
  return widget;
}
