import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:agro_cloud/components/common_drawer.dart';
import 'package:get/get.dart';
import 'package:agro_cloud/utils.Dart';
import '../controller/switch_controller.dart';

class Controls extends StatefulWidget {
  Controls({Key key}) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  SwitchController switcher = Get.find();
  // bool isLiveState = false;
  bool ledStatus1;
  bool ledStatus2 = false;
  bool ledStatus3 = false;
  bool ledStatus4 = false;

  @override
  void initState() {
    super.initState();
  }

  // isLive() {
  //   final re = fb.switcher.fbReference();

  //   re.child("TimeStamp").once().then((DataSnapshot data) {
  //     int diff = 0;
  //     String time = data.value;
  //     List<String> splitted = time.split(RegExp(r"[T,+]"));

  //     String currTime =
  //         new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

  //     DateTime nowTime = DateTime.parse(currTime);
  //     DateTime lastTime = DateTime.parse(splitted[0] + ' ' + splitted[1]);
  //     diff = nowTime.difference(lastTime).inSeconds;

  //     if (diff > 8) {
  //       setState(() {
  //         isLiveState = false;
  //       });
  //     } else
  //       setState(() {
  //         isLiveState = true;
  //       });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ledStatus1 = switcher.controlSwitch1.value;
    // final switcher.fbRef = fb.switcher.fbReference();

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
                        Obx(() => FlutterSwitch(
                              activeToggleColor: Colors.green,
                              activeColor: Colors.grey[200],
                              inactiveColor: Colors.black26,
                              toggleSize: 20,
                              valueFontSize: 15,
                              width: 60,
                              height: 25,
                              showOnOff: true,
                              activeTextColor: Colors.black45,
                              inactiveTextColor: Colors.blue[50],
                              value: switcher.controlSwitch1.value,
                              onToggle: (value) {
                                switcher.controlSwitch1.value = value;
                                if (switcher.controlSwitch1.value) {
                                  switcher.fbRef.child("LED").set(1);
                                } else {
                                  switcher.fbRef.child("LED").set(0);
                                }
                              },
                            )),
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
                        Obx(() => FlutterSwitch(
                              activeToggleColor: Colors.green,
                              activeColor: Colors.grey[200],
                              inactiveColor: Colors.black26,
                              toggleSize: 20,
                              valueFontSize: 15,
                              width: 60,
                              height: 25,
                              showOnOff: true,
                              activeTextColor: Colors.black45,
                              inactiveTextColor: Colors.blue[50],
                              value: switcher.controlSwitch2.value,
                              onToggle: (value) {
                                switcher.controlSwitch2.value = value;
                                if (switcher.controlSwitch2.value) {
                                  switcher.fbRef.child("S2").set(1);
                                } else {
                                  switcher.fbRef.child("S2").set(0);
                                }
                              },
                            )),
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
                        Obx(() => FlutterSwitch(
                              activeToggleColor: Colors.green,
                              activeColor: Colors.grey[200],
                              inactiveColor: Colors.black26,
                              toggleSize: 20,
                              valueFontSize: 15,
                              width: 60,
                              height: 25,
                              showOnOff: true,
                              activeTextColor: Colors.black45,
                              inactiveTextColor: Colors.blue[50],
                              value: switcher.controlSwitch3.value,
                              onToggle: (value) {
                                switcher.controlSwitch3.value = value;
                                if (switcher.controlSwitch3.value) {
                                  switcher.fbRef.child("S3").set(1);
                                } else {
                                  switcher.fbRef.child("S3").set(0);
                                }
                              },
                            )),
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
                        Obx(() => FlutterSwitch(
                              activeToggleColor: Colors.green,
                              activeColor: Colors.grey[200],
                              inactiveColor: Colors.black26,
                              toggleSize: 20,
                              valueFontSize: 15,
                              width: 60,
                              height: 25,
                              showOnOff: true,
                              activeTextColor: Colors.black45,
                              inactiveTextColor: Colors.blue[50],
                              value: switcher.controlSwitch4.value,
                              onToggle: (value) {
                                switcher.controlSwitch4.value = value;
                                if (switcher.controlSwitch4.value) {
                                  switcher.fbRef.child("S4").set(1);
                                } else {
                                  switcher.fbRef.child("S4").set(0);
                                }
                              },
                            )),
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
