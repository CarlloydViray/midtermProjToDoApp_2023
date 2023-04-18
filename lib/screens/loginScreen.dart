import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midtermprojecttodoapp/screens/registerScreen.dart';
import 'package:midtermprojecttodoapp/screens/todoScreen.dart';
import 'package:quickalert/quickalert.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true;

  void login() async {
    if (_formkey.currentState!.validate()) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Checking user credentials...');

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((UserCredential) async {
        if (mounted) {
          Navigator.pop(context);
          String collectionPath = 'user';
          String uid = UserCredential.user!.uid;
          final docSnapshot = await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(UserCredential.user!.uid)
              .get();

          dynamic data = docSnapshot.data();

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: ((context) {
                return todoScreen();
              }),
            ),
          );
          Navigator.pop(context);
        }
      }).catchError((err) {
        if (mounted) {
          Navigator.pop(context);
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Invalid email and/or password');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputTextSize = TextStyle(
      fontSize: 16,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Image(
                          image: AssetImage('lib/assets/icons/1024.png'),
                          height: 150, // set height to 200 pixels
                          width: 150,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'ToDo Application',
                          style: GoogleFonts.dynaPuff(),
                        ),
                        Text(
                          'By: Carlloyd Viray IT3D',
                          style: GoogleFonts.bitter(),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                  const Text('Sign in to your account:'),
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    style: inputTextSize,
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
                    style: inputTextSize,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF393646),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) {
                          return registerScreen();
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF6D5D6E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: const Text('Register new account'),
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
