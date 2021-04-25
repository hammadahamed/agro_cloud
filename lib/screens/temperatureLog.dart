import 'dart:async';

import 'package:agro_cloud/components/common_drawer.dart';
import 'package:agro_cloud/components/dummy_charts.dart';
import 'package:agro_cloud/components/exportCSV.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:agro_cloud/utils.Dart';
import 'package:agro_cloud/controller/data_controller.dart';

class TemperatureLog extends StatefulWidget {
  @override
  _TemperatureLogState createState() => _TemperatureLogState();
}

class _TemperatureLogState extends State<TemperatureLog>
    with TickerProviderStateMixin {
  DataController dataController = Get.find();
  final fb = FirebaseDatabase.instance;
  bool isLiveState = false;

  // GENERATE ROWS
  List<DataRow> getRows() {
    dataController.isDataLoading.value = true;
    print(">>>> cchange TRUE");

    List<DataRow> rows = [];
    for (var i = 0; i < dataController.date.length; i++) {
      var item = DataRow(
        cells: <DataCell>[
          DataCell(Text((i + 1).toString())),
          DataCell(Text(dataController.date[i])),
          DataCell(Text(dataController.time[i])),
          DataCell(Text(dataController.temperature[i])),
          // DataCell(Text("--")),
        ],
      );

      rows.add(item);
    }
    dataController.isDataLoading.value = false;
    print(">>>> cchange FALSE");
    return rows;
  }

// ------- ALL DATA ---------------------------------

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
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      isLive();
    });
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

    List<dynamic> date = dataController.date;
    List<dynamic> time = dataController.time;
    List<dynamic> temperature = dataController.temperature;

    return SafeArea(
      child: Scaffold(
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
                    dataController.getData();
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
                child: DummyCharts(),
              ),
              // THIRD HALF
              Container(
                height: Get.height * .45,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Obx(() => DataTable(
                        columnSpacing: 15,
                        columns: dataController.isDataLoading.value
                            ? <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'Loading ... ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink[600],
                                    ),
                                  ),
                                )
                              ]
                            : <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'S. No. \n(' +
                                        dataController.time.length.toString() +
                                        ")",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Time',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Temperature',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                        dividerThickness:
                            dataController.isDataLoading.value ? 0 : 1,
                        rows: dataController.isDataLoading.value
                            ? [
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text("")),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Center(
                                      child: SpinKitDoubleBounce(
                                        color: MyColors.primaryColor,
                                        size: 50.0,
                                      ),
                                    )),
                                  ],
                                ),
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text("")),
                                  ],
                                ),
                              ]
                            : getRows())),
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
