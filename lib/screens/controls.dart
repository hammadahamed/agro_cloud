import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:agro_cloud/components/common_drawer.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:agro_cloud/utils.Dart';

class Controls extends StatefulWidget {
  Controls({Key key}) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final fb = FirebaseDatabase.instance;
  bool isLiveState = false;
  bool ledStatus1 = false;
  bool ledStatus2 = false;
  bool ledStatus3 = false;
  bool ledStatus4 = false;
  isLive() {
    final re = fb.reference();

    re.child("TimeStamp").once().then((DataSnapshot data) {
      int diff = 0;
      String time = data.value;
      List<String> splitted = time.split(RegExp(r"[T,+]"));

      String currTime =
          new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      DateTime nowTime = DateTime.parse(currTime);
      DateTime lastTime = DateTime.parse(splitted[0] + ' ' + splitted[1]);
      diff = nowTime.difference(lastTime).inSeconds;

      if (diff > 8) {
        setState(() {
          isLiveState = false;
        });
      } else
        setState(() {
          isLiveState = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    return SafeArea(
        child: Scaffold(
      drawer: CommonDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.primaryColor,
        ),
        foregroundColor: Colors.blueGrey,
        backgroundColor: Colors.white,
        title: Text(
          "Controls",
          style: TextStyle(
            fontFamily: "NunitoSans-semibold",
            color: MyColors.primaryColor,
          ),
        ),
      ),
      body: Container(
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: Get.height * 0.01,
            // ),
            Spacer(),
            Container(
              width: Get.width / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Control center",
                    style: TextStyle(
                        fontSize: Get.width * .1,
                        color: MyColors.primaryColor,
                        fontFamily: "NunitoSans-semibold"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "\n- Kindly check for once, if expected perpherals are connetced to the appropriate switches",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Get.width * .035,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "\n- PIN represent the pin number in the Micro-controller, to the wich that particular switch is associated",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Get.width * .035,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            // ROW 1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          child: Text(
                            "Switch 1\nPIN : 6",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        FlutterSwitch(
                          activeToggleColor: Colors.green,
                          activeColor: Colors.black12,
                          inactiveColor: Colors.black26,
                          toggleSize: 20,
                          valueFontSize: 15,
                          width: 60,
                          height: 25,
                          showOnOff: true,
                          activeTextColor: Colors.black,
                          inactiveTextColor: Colors.blue[50],
                          value: ledStatus1,
                          onToggle: (value) {
                            setState(() {
                              ledStatus1 = value;
                              if (ledStatus1) {
                                ref.child("LED").set(1);
                              } else {
                                ref.child("LED").set(0);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          child: Text(
                            "Switch 2\nPIN : 7",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        FlutterSwitch(
                          activeToggleColor: Colors.green,
                          activeColor: Colors.black12,
                          inactiveColor: Colors.black26,
                          toggleSize: 20,
                          valueFontSize: 15,
                          width: 60,
                          height: 25,
                          showOnOff: true,
                          activeTextColor: Colors.black,
                          inactiveTextColor: Colors.blue[50],
                          value: ledStatus2,
                          onToggle: (value) {
                            setState(() {
                              ledStatus2 = value;
                              if (ledStatus2) {
                                ref.child("LED").set(1);
                              } else {
                                ref.child("LED").set(0);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),

            // ROW 2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          child: Text(
                            "Switch 3\nPIN : 8",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        FlutterSwitch(
                          activeToggleColor: Colors.green,
                          activeColor: Colors.black12,
                          inactiveColor: Colors.black26,
                          toggleSize: 20,
                          valueFontSize: 15,
                          width: 60,
                          height: 25,
                          showOnOff: true,
                          activeTextColor: Colors.black,
                          inactiveTextColor: Colors.blue[50],
                          value: ledStatus3,
                          onToggle: (value) {
                            setState(() {
                              ledStatus3 = value;
                              if (ledStatus3) {
                                ref.child("LED").set(1);
                              } else {
                                ref.child("LED").set(0);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          child: Text(
                            "Switch 4\nPIN : 9",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        FlutterSwitch(
                          activeToggleColor: Colors.green,
                          activeColor: Colors.black12,
                          inactiveColor: Colors.black26,
                          toggleSize: 20,
                          valueFontSize: 15,
                          width: 60,
                          height: 25,
                          showOnOff: true,
                          activeTextColor: Colors.black,
                          inactiveTextColor: Colors.blue[50],
                          value: ledStatus4,
                          onToggle: (value) {
                            setState(() {
                              ledStatus4 = value;
                              if (ledStatus4) {
                                ref.child("LED").set(1);
                              } else {
                                ref.child("LED").set(0);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            // SizedBox(height: Get.height * .2)
          ],
        ),
      ),
    ));
  }
}
