import 'package:flutter/material.dart';
import 'package:flutter_first_class/page/login.dart';
import 'package:flutter_first_class/page/signup.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Signup()
    );
  }
}
