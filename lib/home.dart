import 'dart:async';
import 'package:agro_cloud/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'datasTable.dart';


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
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            User(userdetails: widget.detailsUser)));
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: Center(child: Text("Menu")),
                //       content: Container(
                //         height: 250,
                //         child: StatefulBuilder(
                //           builder:
                //               (BuildContext context, StateSetter setState) {
                //             return
                //           },
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "avatar",
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(widget.detailsUser.photoUrl),
                  ),
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
                                            Text("Humidity",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            SvgPicture.asset(
                                              'assets/icons/humidity.svg',
                                              height: 80,
                                            ),
                                            Text(
                                              snap.data.snapshot
                                                  .value["DHT11Humidity"],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
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
                                            Text("Temperature",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                            SvgPicture.asset(
                                              'assets/icons/thermometer.svg',
                                              height: 80,
                                            ),
                                            Text(
                                                snap.data.snapshot
                                                    .value["DHT11Temperature"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20))
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
                                        Text("Soil Moisture",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                        Image.asset(
                                          'assets/photo/soilmoisture.png',
                                          height: 80,
                                        ),
                                        Text("30%",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20))
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
