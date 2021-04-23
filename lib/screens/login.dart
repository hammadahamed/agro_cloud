import 'package:agro_cloud/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_button/sign_button.dart';
import '../home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/photo/SplashGIF.gif'),
                fit: BoxFit.cover),
          ),
        ),
        // pit stop
        Opacity(
          opacity: .8,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                // Colors.black54,
                Colors.black,
              ],
            )),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // pit stop
              Text(
                "WELCOME",
                style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black12,
                        offset: Offset(4.0, 1.0),
                      ),
                    ],
                    fontSize: 70,
                    fontFamily: "NunitoSans-regular",
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
              Text(
                "THE CLOUD BASED APP FOR YOUR SYSTEM",
                textAlign: TextAlign.center,
                style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black45,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                    fontSize: 16,
                    fontFamily: "NunitoSans-semibold",
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
              Spacer(),
              Center(
                child: SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () {
                    // SIGN iin LOGIC
                    auth.signIn();
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  auth.userObj = null;
                  Get.off(() => Home());
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                child: Text("Login as Guest",
                    style: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
