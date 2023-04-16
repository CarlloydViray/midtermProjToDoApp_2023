import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  final fnameController = TextEditingController();
  final mnameController = TextEditingController();
  final lnameController = TextEditingController();
  final bday = TextEditingController();
  final addressController = TextEditingController();

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
      //created user account -> UID
      String uid = userCredential.user!.uid;
      FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(uid)
          .set({'todo': [], 'finished': []});
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'User Created!');
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return todoScreen();
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
    //cause form to validate

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
          'Sign Up (Client)',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  onPressed: () {
                    validateInput();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
