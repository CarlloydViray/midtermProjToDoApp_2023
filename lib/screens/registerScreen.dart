import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:midtermprojecttodoapp/authGate.dart';
import 'package:midtermprojecttodoapp/screens/homeScreen.dart';
import 'package:midtermprojecttodoapp/screens/loginScreen.dart';
import 'package:midtermprojecttodoapp/screens/todoScreen.dart';
import 'package:quickalert/quickalert.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  var obscurePassword = true;
  final _formkey = GlobalKey<FormState>();
  final collectionPath = 'users';

  void registerClient() async {
    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }
      String uid = userCredential.user!.uid;
      FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(uid)
          .set({'todo': [], 'finished': []});
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return authGate();
          },
        ),
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title:
                'Your password is weak. Please enter more than 6 characters.');
        return;
      }
      if (ex.code == 'email-already-in-use') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title:
                'Your email is already registered. Please enter a new email address.');
        return;
      }
      if (ex.code == 'null-usercredential') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'An error occured while creating your account. Try again.');
      }

      print(ex.code);
    }
  }

  void validateInput() {
    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: null,
        confirmBtnText: 'Yes',
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          registerClient();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register account',
          style: TextStyle(color: Color(0xFFF4EEE0)),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFFF4EEE0),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  const Text('Register your account:'),
                  const SizedBox(
                    height: 12.0,
                  ),
                  //email
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required. Please enter an email address.';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email address';
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),

                  //password
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required. Please enter your password.';
                      }
                      if (value.length <= 6) {
                        return 'Password must be more than 6 characters';
                      }
                    },
                    obscureText: obscurePassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),

                  //confirm password
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required. Please enter your password.';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords don\'t match';
                      }
                    },
                    obscureText: obscurePassword,
                    controller: confirmpassController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: validateInput,
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF393646),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
