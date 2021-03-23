import 'package:flutter/material.dart';
import 'login.dart';
import 'spalsh.dart';
import 'home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => Splash(),
        '/home': (_) => Home(),
        '/splash': (_) => Splash(),
        '/login': (_) => Login(),
       
      },
    );
  }
}
