import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class User extends StatefulWidget {
  final GoogleSignInAccount userdetails;
  final bool guest;

  User({Key key, this.userdetails, this.guest}) : super(key: key);
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Container(
              height: 300,
              child: Card(
                  child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              widget.guest
                                  ? "Guest"
                                  : widget.userdetails.displayName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: "NunitoSans-regular",
                              ),
                            ),
                          ),
                          Text(
                            widget.guest ? "" : widget.userdetails.email,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Hero(
                        tag: "avatar",
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 50.0,
                            child: widget.guest
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                : null,
                            backgroundImage: widget.guest
                                ? null
                                : NetworkImage(widget.userdetails.photoUrl),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: widget.guest
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceEvenly,
                    children: [
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
                        activeIcon: SvgPicture.asset('assets/icons/night.svg',
                            height: 150),
                        inactiveIcon: SvgPicture.asset('assets/icons/sun.svg',
                            height: 150),

                        onToggle: (val) {
                          setState(() {
                            isDark = val;
                            Get.isDarkMode
                                ? Get.changeTheme(ThemeData.light())
                                : Get.changeTheme(ThemeData.dark());
                          });
                        },
                      ),
                      widget.guest
                          ? SizedBox()
                          : ElevatedButton(
                              onPressed: () async {
                                await googleSignIn.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                    (route) => false);
                              },
                              child: Text("Sign Out")),
                    ],
                  ),
                ],
              )),
            ),
            Spacer(),
            Text(
              "Agro Cloud",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("A cloud Based Monitoring app for your Farm",
                style: TextStyle(fontSize: 15)),
            Spacer(),
          ],
        ),
      ),
    );
    // Scaffold(

    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       Row(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Hero(
    //               tag: "avatar",
    //               child: CircleAvatar(
    //                 radius: 20.0,
    //                 backgroundImage: NetworkImage(widget.userdetails.photoUrl),
    //               ),
    //             ),
    //           ),
    //           Text(
    //             widget.userdetails.displayName,
    //             style: TextStyle(fontWeight: FontWeight.bold),
    //           ),
    //         ],
    //       ),
    //       Text(widget.userdetails.email),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           Text("Change Theme"),
    //           FlutterSwitch(
    //             value: isDark,
    //             activeToggleColor: Colors.black,
    //             inactiveToggleColor: Colors.teal,
    //             // activeSwitchBorder: Border.all(
    //             //   color: Color(0xFF00D2B8),
    //             //   width: 2.0,
    //             // ),
    //             // inactiveSwitchBorder: Border.all(
    //             //   color: Colors.white,
    //             //   width: 2.0,
    //             // ),
    //             // activeColor: Color(0xFF55DDCA),
    //             // inactiveColor: Color(0xFF54C5F8),
    //             activeIcon:
    //                 SvgPicture.asset('assets/icons/night.svg', height: 150),
    //             inactiveIcon:
    //                 SvgPicture.asset('assets/icons/sun.svg', height: 150),

    //             onToggle: (val) {
    //               setState(() {
    //                 isDark = val;
    //                 Get.isDarkMode
    //                     ? Get.changeTheme(ThemeData.light())
    //                     : Get.changeTheme(ThemeData.dark());
    //               });
    //             },
    //           ),
    //         ],
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 15),
    //         child: ElevatedButton(
    //           onPressed: () async {
    //             await googleSignIn.signOut();
    //             Navigator.pushAndRemoveUntil(
    //                 context,
    //                 MaterialPageRoute(builder: (context) => Login()),
    //                 (route) => false);
    //           },
    //           child: Text("Sign Out"),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
