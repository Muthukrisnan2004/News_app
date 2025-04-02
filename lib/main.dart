import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: App(), // Updated to reference your home screen
    );
  }
}
