import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:agro_cloud/utils.Dart';

class HumidityLog extends StatefulWidget {
  @override
  _HumidityLogState createState() => _HumidityLogState();
}

class _HumidityLogState extends State<HumidityLog>
    with TickerProviderStateMixin {
  final fb = FirebaseDatabase.instance;
  bool isLiveState = false;
  List<String> humidity = [];
  List<String> time = [];
  List<String> date = [];
  List<String> dateTime = [];
  List<DataRow> allRow = [];
  bool isLoad = false;
  allData() async {
    time.clear();

    humidity.clear();
    DateTime frmt;
    String t;
    final ref = fb.reference();
    await ref.child("DataArray").once().then((DataSnapshot data) {
      data.value["DateTime"].forEach((key, value) => {
            dateTime = value.split(RegExp(r"[T,+]")),
            frmt = new DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(dateTime[0] + " " + dateTime[1]),
            t = new TimeOfDay(
              hour: frmt.hour,
              minute: frmt.minute,
            ).format(context),
            t = t.replaceFirst(" ", ":" + frmt.second.toString() + " "),
            print(t),
            time.add(t),
            date.add(dateTime[0])
          });

      data.value["Humidity"].forEach((key, value) => {
            humidity.add(value),
          });
    });

    setState(() {
      allRow.clear();
    });

    for (var i = 0; i < time.length; i++) {
      setState(() {
        allRow.add(
          DataRow(
            selected: i % 2 == 0 ? true : false,
            cells: <DataCell>[
              DataCell(Text(date[i])),
              DataCell(Text(time[i])),
              DataCell(Text(humidity[i])),
            ],
          ),
        );
      });
    }
  }

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
    allData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: MyColors.primaryColor),
          title: Text(
            "Humidity Logs",
            style: TextStyle(
                fontFamily: "NunitoSans-semibold",
                color: Get.isDarkMode ? Colors.white : MyColors.primaryColor),
          ),
          backgroundColor: Get.isDarkMode ? null : Colors.white,
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  setState(() {
                    isLoad = true;
                  });
                  await Future.delayed(Duration(milliseconds: 3000), () {
                    allData();
                  });
                  setState(() {
                    isLoad = false;
                  });
                })
          ],
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // First HALF
              Row(
                children: [
                  Hero(
                    tag: "HumIcon",
                    child: Image(
                      height: 30,
                      image: AssetImage(
                        'assets/photo/humidity.png',
                      ),
                    ),
                  ),
                  Text("Humidity"),
                  Spacer(),
                  Container(
                    width: Get.width / 3,
                    child: isLiveState
                        ? FadeTransition(
                            opacity: CurvedAnimation(
                                parent: AnimationController(
                                  duration: const Duration(milliseconds: 750),
                                  vsync: this,
                                )..repeat(reverse: true),
                                curve: Curves.easeIn),
                            child: Row(
                              children: [
                                Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  maxRadius: 5,
                                ),
                                Text(
                                  "Live",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                              ],
                            ),
                          )
                        : Container(
                            child: Row(
                              children: [
                                Spacer(),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  maxRadius: 5,
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
                  )
                ],
              ),
              // SECOND HALF
              Container(
                margin: EdgeInsets.only(top: 10),
                color: MyColors.primaryColor,
                height: Get.height * .3,
              ),
              // THIRD HALF
              Container(
                height: Get.height * .45,
                child: SingleChildScrollView(
                  child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Humidity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      dividerThickness: isLoad ? 0 : 1,
                      rows: !isLoad
                          ? allRow
                          : [
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Text(""),
                                  ),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text("")),
                                  DataCell(Center(
                                    child: SpinKitDoubleBounce(
                                      color: MyColors.primaryColor,
                                      size: 50.0,
                                    ),
                                  )),
                                  DataCell(Text("")),
                                ],
                              ),
                            ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
