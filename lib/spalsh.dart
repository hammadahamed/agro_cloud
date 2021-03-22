import 'package:flutter/material.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(milliseconds: 3000),
        () => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login())));
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}
