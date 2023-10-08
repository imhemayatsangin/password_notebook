import 'package:flutter/material.dart';
import 'package:password_notebook/uiscreens/home_screen.dart'; // Import the home_screen.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Notebook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 8, 166, 213),
        ),
        useMaterial3: false,
      ),
      home: const MyHomePage(
          title: 'Password Notebook'), // Use MyHomePage from home_screen.dart
      debugShowCheckedModeBanner: false,
    );
  }
}
