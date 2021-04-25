import 'dart:async';

import 'package:agro_cloud/components/common_drawer.dart';
import 'package:agro_cloud/components/custom_charts.dart';
import 'package:agro_cloud/components/dummy_charts.dart';
import 'package:agro_cloud/components/exportCSV.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:agro_cloud/utils.Dart';
import 'package:agro_cloud/controller/data_controller.dart';

class DatasTable extends StatefulWidget {
  @override
  _DatasTableState createState() => _DatasTableState();
}

class _DatasTableState extends State<DatasTable> with TickerProviderStateMixin {
  DataController dataController = Get.find();
  final fb = FirebaseDatabase.instance;
  bool isLiveState = false;
  var soilMoisture = [];

  // GENERATE ROWS
  List<DataRow> getRows() {
    dataController.isDataLoading.value = true;
    print(">>>> cchange TRUE");

    List<DataRow> rows = [];
    for (var i = 0; i < dataController.date.length; i++) {
      soilMoisture.add("NA");
      var item = DataRow(
        cells: <DataCell>[
          DataCell(Text(dataController.date[i])),
          DataCell(Text(dataController.time[i])),
          DataCell(Text(dataController.humidity[i])),
          DataCell(Text(dataController.temperature[i])),
          DataCell(Text("NA")),
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
    List<dynamic> date = dataController.date;
    List<dynamic> time = dataController.time;
    List<dynamic> humidity = dataController.humidity;
    List<dynamic> temperature = dataController.temperature;

    return SafeArea(
      child: Scaffold(
        drawer: CommonDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: MyColors.primaryColor),
          title: Text(
            "All Data Logs",
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
                                allCsv(date, time, temperature, humidity,
                                    soilMoisture);
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
                      dataController.getData();
                    });
                  },
                ),
              ],
            )
          ],
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Obx(() => DataTable(
                    columnSpacing: Get.width * .035,
                    horizontalMargin: 10,
                    headingRowHeight: 75,
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
                                'Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[600],
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[600],
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Humidity\n( % )',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[600],
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Temperature\n( °c )',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[600],
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Soil\nMoisture',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink[600],
                                ),
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
        ),
      ),
    );
  }
}
