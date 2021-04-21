import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class User extends StatefulWidget {
  final GoogleSignInAccount userdetails;
  User({Key key, this.userdetails}) : super(key: key);
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // bottom: PreferredSize(preferredSize: ,),
        backgroundColor: Colors.white10,
        foregroundColor: Colors.white10,
        elevation: 10,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "avatar",
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(widget.userdetails.photoUrl),
                  ),
                ),
              ),
              Text(
                widget.userdetails.displayName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(widget.userdetails.email),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Change Theme"),
              FlutterSwitch(
                value: isDark,
                activeToggleColor: Colors.black,
                inactiveToggleColor: Colors.teal,
                // activeSwitchBorder: Border.all(
                //   color: Color(0xFF00D2B8),
                //   width: 2.0,
                // ),
                // inactiveSwitchBorder: Border.all(
                //   color: Colors.white,
                //   width: 2.0,
                // ),
                // activeColor: Color(0xFF55DDCA),
                // inactiveColor: Color(0xFF54C5F8),
                activeIcon:
                    SvgPicture.asset('assets/icons/night.svg', height: 150),
                inactiveIcon:
                    SvgPicture.asset('assets/icons/sun.svg', height: 150),

                onToggle: (val) {
                  setState(() {
                    isDark = val;
                    Get.isDarkMode
                        ? Get.changeTheme(ThemeData.light())
                        : Get.changeTheme(ThemeData.dark());
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ElevatedButton(
              onPressed: () async {
                await googleSignIn.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              },
              child: Text("Sign Out"),
            ),
          ),
        ],
      ),
    );
  }
}
