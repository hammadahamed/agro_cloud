import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:agro_cloud/home.dart';
import 'login.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:simple_animations/simple_animations.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool signIn;
  GoogleSignInAccount userObj;
  GoogleSignIn googleSignIn = GoogleSignIn();
  void isSignn() async {
    signIn = await googleSignIn.isSignedIn();
    if (signIn) {
      userObj = await googleSignIn.signInSilently();
      await Future.delayed(
          Duration(milliseconds: 3000),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Home(
                    detailsUser: userObj,
                  ))));
    } else {
      await Future.delayed(
          Duration(milliseconds: 3000),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Login())));
    }
  }

  @override
  void initState() {
    super.initState();
    isSignn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 50.0,
      )),
    );
  }
}
