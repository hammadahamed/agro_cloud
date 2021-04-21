import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'datasTable.dart';
import 'login.dart';

class Home extends StatefulWidget {
  final GoogleSignInAccount detailsUser;
  Home({Key key, this.detailsUser}) : super(key: key);
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with TickerProviderStateMixin {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final fb = FirebaseDatabase.instance;
  bool ledStatus = false;
  bool isLiveState = false;
  bool isDark = false;

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
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      isLive();
      isDark = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    return Scaffold(
        appBar: AppBar(
          title: Text("Agro Cloud"),
          actions: <Widget>[
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(child: Text("Menu")),
                      content: Container(
                        height: 250,
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 20.0,
                                        backgroundImage: NetworkImage(
                                            widget.detailsUser.photoUrl),
                                      ),
                                    ),
                                    Text(
                                      widget.detailsUser.displayName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(widget.detailsUser.email),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                      activeIcon: SvgPicture.asset(
                                          'assets/icons/night.svg',
                                          height: 150),
                                      inactiveIcon: SvgPicture.asset(
                                          'assets/icons/sun.svg',
                                          height: 150),

                                      onToggle: (val) {
                                        setState(() {
                                          isDark = val;
                                          Get.isDarkMode
                                              ? Get.changeTheme(
                                                  ThemeData.light())
                                              : Get.changeTheme(
                                                  ThemeData.dark());
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
                                          MaterialPageRoute(
                                              builder: (context) => Login()),
                                          (route) => false);
                                    },
                                    child: Text("Sign Out"),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(widget.detailsUser.photoUrl),
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: ref.onValue,
          builder: (context, snap) {
            return snap.data == null
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          isLiveState
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 9.0),
                                  child: FadeTransition(
                                    opacity: CurvedAnimation(
                                        parent: AnimationController(
                                          duration:
                                              const Duration(milliseconds: 750),
                                          vsync: this,
                                        )..repeat(reverse: true),
                                        curve: Curves.easeIn),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            maxRadius: 5,
                                          ),
                                        ),
                                        Text(
                                          "Live",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 9.0),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          maxRadius: 5,
                                        ),
                                      ),
                                      Text(
                                        "Disconnected",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                          // ListTile(
                          //   title: Text("Time Stamp"),
                          //   trailing: Text(snap.data.snapshot.value["TimeStamp"]
                          //       .toString()),
                          // ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  height: 150,
                                  width: 150,
                                  child: Card(
                                      elevation: 15,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("Humidity",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                                            SvgPicture.asset(
                                              'assets/icons/humidity.svg',
                                              height: 80,
                                            ),
                                            Text(snap.data.snapshot
                                                .value["DHT11Humidity"],style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20),)
                                          ],
                                        ),
                                      ))),
                              Container(
                                  height: 150,
                                  width: 150,
                                  child: Card(
                                      elevation: 15,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text("Temperature",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                                            SvgPicture.asset(
                                              'assets/icons/thermometer.svg',
                                              height: 80,
                                            ),
                                            Text(snap.data.snapshot
                                                .value["DHT11Temperature"],style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20))
                                          ],
                                        ),
                                      ))),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                              height: 150,
                              width: 150,
                              child: Card(
                                  elevation: 15,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Soil Moisture",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20)),
                                        Image.asset(
                                          'assets/photo/soilmoisture.png',
                                          height: 80,
                                        ),
                                        Text("30%",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20))
                                      ],
                                    ),
                                  ))),
                          SizedBox(height: 20),
                          Container(
                              height: 150,
                              width: 150,
                              child: Card(
                                  elevation: 15,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Control Switch"),
                                        FlutterSwitch(
                                          showOnOff: true,
                                          activeTextColor: Colors.black,
                                          inactiveTextColor: Colors.blue[50],
                                          value: ledStatus,
                                          onToggle: (value) {
                                            setState(() {
                                              ledStatus = value;
                                              if (ledStatus) {
                                                ref.child("LED").set(1);
                                              } else {
                                                ref.child("LED").set(0);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ))),
                          SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => DatasTable()));
                            },
                            child: Text("All Data"),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ));
  }
}
