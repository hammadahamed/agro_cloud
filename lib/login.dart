import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedin = false;
  GoogleSignInAccount userObj;
  GoogleSignIn googleSignIn = GoogleSignIn();

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
        Container(
          color: Colors.green.withOpacity(0.5),
        ),
        Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "WELCOME",
                style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Spacer(),
              Text(
                "The Cloud Based APP for your Farm",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Spacer(),
              Center(
                child: SignInButton(
                  buttonType: ButtonType.google,
                  onPressed: () async {
                    googleSignIn.signIn().then((userData) {
                      setState(() {
                        userObj = userData;
                      });
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Home(
                                    detailsUser: userObj,
                                  )));
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ]),
    );
  }
}
