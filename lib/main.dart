import 'package:flutter/material.dart';
import 'package:unguser/scaffold/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      title: 'Ung User',
      home: Home(),
    );
  }
}
