import 'package:dominos2/Screens/ContactsList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dominos Tracker',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: SafeArea(child: ContactsList()),
    );
  }
}
