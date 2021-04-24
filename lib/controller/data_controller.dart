import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataController extends GetxController {
  
  final fb = FirebaseDatabase.instance;
  // BuildContext context;
  bool allDataLoading = false;
  RxList<String> humidity;
  RxList<String> temperature;
  RxList<String> time ;
  RxList<String> date ;
  RxList<String> dateTime;
  RxList<DataRow> allRow;


  allData({context}) async {

    time.clear();
    humidity.clear();
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
  }
  dataRows({type}){
  for (var i = 0; i < time.length; i++) {
      int j = i + 1;

      if (i > time.length - 50 && i < time.length) {
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
    }
     return allRow;
}
}

