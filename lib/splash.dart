import 'package:agro_cloud/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:agro_cloud/home.dart';
import 'package:get/get.dart';
import 'screens/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:simple_animations/simple_animations.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool signIn;
  GoogleSignInAccount userObj;
  AuthController auth = Get.find();
  void divertor() async {
    signIn = await auth.googleSignIn.isSignedIn();
    if (signIn) {
      auth.userObj = await auth.googleSignIn.signInSilently();
      print("----------------------------> user obj : >> $userObj");

      Get.to(() => Home());
    } else {
      Get.to(() => Login());
    }
  }

  @override
  void initState() {
    super.initState();
    divertor();
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
