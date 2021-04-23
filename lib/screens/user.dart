import 'package:agro_cloud/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:agro_cloud/utils.Dart';

import 'login.dart';

class User extends StatefulWidget {
  User({Key key}) : super(key: key);
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  AuthController auth = Get.find();
  var user;
  bool isDark = Get.isDarkMode;

  @override
  void initState() {
    user = auth.userObj;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.keyboard_backspace,
                          size: 25,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          Get.back();
                        })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "avatar",
                      child: CircleAvatar(
                        backgroundColor:
                            user == null ? Colors.grey[200] : Colors.black12,
                        radius: Get.width * .2,
                        child: user == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: MyColors.primaryColor,
                              )
                            : null,
                        backgroundImage:
                            user == null ? null : NetworkImage(user.photoUrl),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: Get.width * .6,
                      child: Text(
                        user == null
                            ? "Guest"
                            : user.displayName.toString().split(" ")[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Text(
                      user == null ? "" : user.email,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: FlutterSwitch(
                            value: isDark,
                            activeColor: Colors.black,
                            inactiveColor: Colors.black12,
                            activeToggleColor: Colors.black54,
                            inactiveToggleColor: Colors.white,
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
                            activeIcon: SvgPicture.asset(
                                'assets/icons/night.svg',
                                height: 150),
                            inactiveIcon: SvgPicture.asset(
                                'assets/icons/sun.svg',
                                height: 150),

                            onToggle: (val) {
                              setState(() {
                                isDark = val;
                                print(isDark);
                                Get.isDarkMode
                                    ? Get.changeTheme(ThemeData.light())
                                    : Get.changeTheme(ThemeData.dark());
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[100],
                          child: user == null
                              ? IconButton(
                                  onPressed: () async {
                                    await auth
                                        .signIn()
                                        .then((val) => Get.to(() => User()));
                                  },
                                  iconSize: 35,
                                  icon: Icon(
                                    Icons.login_outlined,
                                    color: Colors.red,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    await auth.googleSignIn.signOut();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()),
                                        (route) => false);
                                  },
                                  iconSize: 35,
                                  icon: Icon(
                                    Icons.power_settings_new_sharp,
                                    color: Colors.red,
                                    // size: 35,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
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
  }
}
