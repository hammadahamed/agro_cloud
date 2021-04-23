import 'dart:async';

import 'package:agro_cloud/components/common_drawer.dart';
import 'package:agro_cloud/components/custom_charts.dart';
import 'package:agro_cloud/components/exportCSV.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:agro_cloud/utils.Dart';

class TemperatureLog extends StatefulWidget {
  @override
  _TemperatureLogState createState() => _TemperatureLogState();
}

class _TemperatureLogState extends State<TemperatureLog>
    with TickerProviderStateMixin {
  final fb = FirebaseDatabase.instance;
  bool isLiveState = false;
  List<String> temperature = [];
  List<String> time = [];
  List<String> date = [];
  List<String> dateTime = [];
  List<DataRow> allRow = [];
  bool isLoad = false;

  allData() async {
    isLoad = true;
    time.clear();
    temperature.clear();
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
            time.add(t),
            date.add(dateTime[0])
          });

      data.value["Temperature"].forEach((key, value) => {
            temperature.add(value),
          });
    });

    setState(() {
      allRow.clear();
    });

//
    for (var i = 0; i < time.length; i++) {
      int j = i + 1;

      allRow.add(
        DataRow(
          selected: i % 2 == 0 ? true : false,
          cells: <DataCell>[
            DataCell(Text("$j")),
            DataCell(Text(date[i])),
            DataCell(Text(time[i])),
            DataCell(Text(temperature[i])),
          ],
        ),
      );

      if (i == time.length - 1) {
        setState(() {
          allRow.add(
            DataRow(
              selected: i % 2 == 0 ? true : false,
              cells: <DataCell>[
                DataCell(Text("$j")),
                DataCell(Text(date[i])),
                DataCell(Text(time[i])),
                DataCell(Text(temperature[i])),
              ],
            ),
          );
          isLoad = false;
        });
      }
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
      if (diff > 8 && isLiveState) {
        setState(() {
          isLiveState = false;
        });
      } else if (diff < 8 && !isLiveState) {
        setState(() {
          isLiveState = true;
        });
      }
    });
  }

  @override
  void initState() {
    allData();
    Timer.periodic(Duration(seconds: 5), (timer) {
      isLive();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      drawer: CommonDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: MyColors.primaryColor),
        title: Text(
          "Temperature Logs",
          style: TextStyle(
            fontFamily: "NunitoSans-semibold",
            color: Get.isDarkMode ? Colors.white : MyColors.primaryColor,
          ),
        ),
        backgroundColor: Get.isDarkMode ? null : Colors.white,
        actions: [
          Row(
            children: [
              IconButton(
                tooltip: "Download Data",
                icon: Icon(Icons.launch_rounded),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Export Data!'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  'Are you sure want to Export All the Data from the Temperature Table?'),
                              // Text(
                              //     'Would you like to approve of this message?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              temperatureCsv(date, time, temperature);
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                tooltip: "Refresh",
                icon: Icon(Icons.refresh),
                onPressed: () {
                  allData();
                },
              ),
            ],
          )
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
                SizedBox(
                  width: 15,
                ),
                Hero(
                  tag: "HumIcon",
                  child: SvgPicture.asset(
                    'assets/icons/thermometer.svg',
                    height: 30,
                  ),
                ),
                Text("Temperature"),
                SizedBox(width: 100),
                Container(
                  width: Get.width / 3,
                  child: isLiveState
                      ? Row(
                          children: [
                            FadeTransition(
                              opacity: CurvedAnimation(
                                  parent: AnimationController(
                                    duration: Duration(milliseconds: 750),
                                    vsync: this,
                                  )..repeat(
                                      reverse: true,
                                      period: Duration(
                                        milliseconds: 1500,
                                      ),
                                    ),
                                  curve: Curves.easeIn),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green,
                                    maxRadius: 5,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Live",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 4),
                            StreamBuilder(
                                stream: ref.onValue,
                                builder: (context, snap) {
                                  return snap.data == null
                                      ? Center(
                                          child: SpinKitDoubleBounce(
                                          color: MyColors.primaryColor,
                                          size: 50.0,
                                        ))
                                      : Text(snap.data.snapshot
                                          .value["DHT11Temperature"]);
                                })
                          ],
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
              child: CustomCharts(),
            ),
            // THIRD HALF
            Container(
              height: Get.height * .45,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      showBottomBorder: true,
                      columnSpacing: 15,
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            "S. No.\n(" + time.length.toString() + ")",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
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
                            'Temperature',
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
                                  DataCell(
                                    Text(""),
                                  ),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                  DataCell(Text("")),
                                ],
                              ),
                            ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
