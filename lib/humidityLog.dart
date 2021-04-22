import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HumidityLog extends StatefulWidget {
  @override
  _HumidityLogState createState() => _HumidityLogState();
}

class _HumidityLogState extends State<HumidityLog>
    with TickerProviderStateMixin {
  final fb = FirebaseDatabase.instance;
  bool isLiveState = false;
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            isLiveState
                ? Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                          parent: AnimationController(
                            duration: const Duration(milliseconds: 750),
                            vsync: this,
                          )..repeat(reverse: true),
                          curve: Curves.easeIn),
                      child: Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              maxRadius: 5,
                            ),
                          ),
                          Text(
                            "Live",
                            style: TextStyle(fontWeight: FontWeight.bold),
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
                          padding: const EdgeInsets.only(right: 5.0),
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
            Center(child: Text("HUMIDITY")),
            Hero(
              tag: "HumIcon",
              child: Image(
                height: 30,
                image: AssetImage(
                  'assets/photo/humidity.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
