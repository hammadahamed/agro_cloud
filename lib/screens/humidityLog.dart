import 'dart:async';

import 'package:agro_cloud/components/custom_charts.dart';
import 'package:agro_cloud/components/exportCSV.dart';
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

  List<DataRow> dataRows;
  List<DataRow> allRow = [];

  bool allDataLoading = false;

// ------- ALL DATA ---------------------------------
  allData() async {
    allDataLoading = true;
    time.clear();

    humidity.clear();
    allRow.clear();
    DateTime frmt;
    String t;
    final ref = fb.reference();

    await ref.child("DataArray").once().then((DataSnapshot data) {
      print("--------------------- DATA ----------------------");
      // print(data.toString());
      print("--------------------- DATA ----------------------");

      // DATE
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
      print("humidity");
      print(data.value["Humidity"]);

      data.value["Humidity"].forEach((key, value) => {
            humidity.add(value),
          });
    });

    for (var i = 0; i < time.length; i++) {
      int j = i + 1;

      allRow.add(
        DataRow(
          selected: i % 2 == 0 ? true : false,
          cells: <DataCell>[
            DataCell(Text("$j")),
            DataCell(Text(date[i])),
            DataCell(Text(time[i])),
            DataCell(Text(humidity[i])),
          ],
        ),
      );
    }
    allDataLoading = true;

    return allRow;
  }

  isLive() async {
    final re = fb.reference();
    await re.child("TimeStamp").once().then((DataSnapshot data) {
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

  Timer timer;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      isLive();
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: MyColors.primaryColor),
          title: Text(
            "Humidity Logs",
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
                                    'Are you sure want to Export All the Data from the Humidity Table?'),
                                // Text(
                                //     'Would you like to approve of this message?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                humidityCsv(date, time, humidity);
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
                      setState(() {
                        allData();
                      });
                    }),
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
                    child: Image(
                      height: 30,
                      image: AssetImage(
                        'assets/photo/humidity.png',
                      ),
                    ),
                  ),
                  Text("Humidity"),
                  SizedBox(width: 130),
                  Container(
                    width: Get.width / 3,
                    child: isLiveState
                        ? Row(
                            children: [
                              FadeTransition(
                                opacity: CurvedAnimation(
                                    parent: AnimationController(
                                      duration:
                                          const Duration(milliseconds: 750),
                                      vsync: this,
                                    )..repeat(reverse: true),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                            .value["DHT11Humidity"]);
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
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                      future: allData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        // snapshot.
                        return DataTable(
                            columnSpacing: 15,
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'S. No. \n(' + time.length.toString() + ")",
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
                                  'Humidity',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            dividerThickness: !snapshot.hasData ? 0 : 1,
                            rows: allDataLoading
                                ? snapshot.data
                                : [
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                        DataCell(Center(
                                          child: SpinKitDoubleBounce(
                                            color: MyColors.primaryColor,
                                            size: 50.0,
                                          ),
                                        )),
                                        DataCell(Text("--")),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                        DataCell(Text("--")),
                                      ],
                                    ),
                                  ]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
