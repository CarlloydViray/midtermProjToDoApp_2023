import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midtermprojecttodoapp/firebase_options.dart';
import 'package:midtermprojecttodoapp/authGate.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(24),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        fontFamily: GoogleFonts.sourceSerifPro().fontFamily,
        scaffoldBackgroundColor: Color(0xFFF4EEE0),
        appBarTheme: AppBarTheme(
            color: Color(0xFF393646),
            titleTextStyle: TextStyle(color: Color(0xF4EEE0))),
      ),
      debugShowCheckedModeBanner: false,
      home: authGate(),
    );
  }
}
