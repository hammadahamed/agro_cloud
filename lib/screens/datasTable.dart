import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:agro_cloud/utils.Dart';

import '../components/exportCSV.dart';

class DatasTable extends StatefulWidget {
  @override
  _DatasTableState createState() => _DatasTableState();
}

class _DatasTableState extends State<DatasTable> {
  final fb = FirebaseDatabase.instance;
  List<String> dateTime = [];
  List<DataRow> allRow = [];
  List<String> temperature = [];
  List<String> time = [];
  List<String> date = [];
  List<String> humidity = [];
  List<String> soilmoisture = [];
  bool isLoad = false;

  allData() async {
    time.clear();
    temperature.clear();
    humidity.clear();
    DateTime frmt;
    String t;
    final ref = fb.reference();
    await ref.child("DataArray").once().then((DataSnapshot data) {
      data.value["DateTime"].forEach((key, value) => {
            soilmoisture.add("NA"),
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
      data.value["Temperature"].forEach((key, value) => {
            temperature.add(value),
          });
      data.value["Humidity"].forEach((key, value) => {
            humidity.add(value),
          });
    });

    setState(() {
      allRow.clear();
    });

    for (var i = 0; i < time.length; i++) {
      int j = i + 1;
      int len = time.length;
      setState(() {
        allRow.add(
          DataRow(
            selected: i % 2 == 0 ? true : false,
            cells: <DataCell>[
              DataCell(Text("$j of $len")),
              DataCell(Text(date[i])),
              DataCell(Text(time[i])),
              DataCell(Text(temperature[i])),
              DataCell(Text(humidity[i])),
              DataCell(Text("NA")),
            ],
          ),
        );
      });
    }
  }

  @override
  void initState() {
    allData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // final ref = fb.reference();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: MyColors.primaryColor),
          backgroundColor: Get.isDarkMode ? null : Colors.white,
          title: Text(
            "All Data Log",
            style: TextStyle(
              fontFamily: "NunitoSans-semibold",
              color: Get.isDarkMode ? Colors.white : MyColors.primaryColor,
            ),
          ),
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
                                    'Are you sure want to Export All the Data Table?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                allCsv(date, time, temperature, humidity,
                                    soilmoisture);
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
                    }),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'S. No.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Temperature',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Humidity',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Soil Moisture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        dividerThickness: isLoad ? 0 : 1,
                        rows: !isLoad
                            ? allRow
                            : [
                                DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text("")),
                                    DataCell(Text("")),
                                    DataCell(Text("")),
                                    DataCell(Text("")),
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
                                    DataCell(Text("")),
                                    DataCell(Text("")),
                                    DataCell(Text("")),
                                  ],
                                ),
                              ]),
                  ],
                ),
              )
            ],
          )),
        ));
  }
}
