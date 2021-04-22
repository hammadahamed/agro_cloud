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
  final bool guest;
  Home({Key key, this.detailsUser, this.guest}) : super(key: key);
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

  Widget oneThirdContainer({Widget content}) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      child: content,
    );
  }

  Widget sideTile({String title, function}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontFamily: "NunitoSans-regular"),
      ),
      onTap: function,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    return SafeArea(
      child: Scaffold(
          // DRAWER
          drawer: Drawer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // USER BANNER
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.8),
                                  BlendMode.dstATop),
                              image: AssetImage(
                                'assets/photo/black_abstract.jpg',
                              ),
                              fit: BoxFit.cover)),
                      height: MediaQuery.of(context).size.height / 4,
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text(
                            widget.guest
                                ? " Welcome \n Guest,\n"
                                : " Welcome" + widget.detailsUser.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: "NunitoSans-regular"),
                          ),
                        ),
                      ),
                    ),
                    // NAVIGATIONS
                    sideTile(
                        title: "Overview",
                        function: () {
                          print("==========");
                        }),
                    sideTile(
                        title: "Analytics",
                        function: () {
                          print("==========");
                        }),
                    sideTile(
                        title: "Temperature log",
                        function: () {
                          print("==========");
                        }),
                    sideTile(
                        title: "Humidity log",
                        function: () {
                          print("==========");
                        }),
                    sideTile(
                        title: "Controls",
                        function: () {
                          print("==========");
                        }),
                    sideTile(
                        title: "Export",
                        function: () {
                          print("==========");
                        }),
                  ],
                ),
              ),
            ),
          ),

          // APPBAR
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.blueGrey),
            foregroundColor: Colors.blueGrey,
            backgroundColor: Colors.white,
            title: Text(
              "Agro Cloud",
              style: TextStyle(
                  fontFamily: "NunitoSans-semibold", color: Colors.blueGrey),
            ),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => User(
                        userdetails: widget.detailsUser,
                        guest: widget.guest,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: "avatar",
                    child: CircleAvatar(
                      backgroundColor: widget.guest ? Colors.blueGrey : null,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      radius: 20.0,
                      backgroundImage: widget.guest
                          ? null
                          : NetworkImage(widget.detailsUser.photoUrl),
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
                                            duration: const Duration(
                                                milliseconds: 750),
                                            vsync: this,
                                          )..repeat(reverse: true),
                                          curve: Curves.easeIn),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
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
                                              fontFamily: "NunitoSans-regular",
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
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: MediaQuery.of(context).size.height / 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      height:
                                          (MediaQuery.of(context).size.height /
                                                  2) /
                                              3.3,
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                          child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Image(
                                                  height: 30,
                                                  image: AssetImage(
                                                    'assets/photo/humidity.png',
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                oneThirdContainer(
                                                  content: Text(
                                                    "HUMIDITY",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSans-bold",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            oneThirdContainer(
                                              content: Text(
                                                snap.data.snapshot
                                                    .value["DHT11Humidity"],
                                                style: TextStyle(
                                                    fontFamily:
                                                        "NunitoSans-light",
                                                    fontSize: 28),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.chevron_right),
                                              onPressed: () {},
                                            )
                                          ],
                                        ),
                                      ))),
                                  Container(
                                    height:
                                        (MediaQuery.of(context).size.height /
                                                2) /
                                            3.3,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/thermometer.svg',
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                oneThirdContainer(
                                                  content: Text(
                                                    "TEMPERATURE",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSans-bold",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            oneThirdContainer(
                                              content: Text(
                                                  snap.data.snapshot.value[
                                                      "DHT11Temperature"],
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "NunitoSans-light",
                                                      fontSize: 28)),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.chevron_right),
                                              onPressed: () {},
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:
                                        (MediaQuery.of(context).size.height /
                                                2) /
                                            3.3,
                                    width: MediaQuery.of(context).size.width,
                                    child: Card(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/photo/soilmoisture.png',
                                                  height: 45,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                oneThirdContainer(
                                                  content: Text(
                                                    "SOIL MOISTURE",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSans-bold",
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            oneThirdContainer(
                                              content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Text(
                                                  "30%",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "NunitoSans-light",
                                                      fontSize: 28),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.chevron_right),
                                              onPressed: () {},
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50,
                                        child: Text(
                                          "Control Switch",
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
                                )),
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
          )),
    );
  }
}
