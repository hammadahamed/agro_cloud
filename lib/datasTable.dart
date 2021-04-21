import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:permission/permission.dart';

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

  allData() async {
    time.clear();
    temperature.clear();
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
      setState(() {
        allRow.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Text(date[i])),
              DataCell(Text(time[i])),
              DataCell(Text(temperature[i])),
              DataCell(Text(humidity[i])),
            ],
          ),
        );
      });
    }
  }

//   getCsv() async {

//  //create an element rows of type list of list. All the above data set are stored in associate list
// //Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

//  List<List<dynamic>> rows = dateTime;
//   for (int i = 0; i <time.length;i++) {

// //row refer to each column of a row in csv file and rows refer to each row in a file
//     List<dynamic> row = List();
//     row.add(associateList[i].name);
//     row.add(associateList[i].gender);
//     row.add(associateList[i].age);
//     rows.add(row);
//   }

//  await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
//   bool checkPermission=await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
//   if(checkPermission) {

// //store file in documents folder

//     String dir = (await getExternalStorageDirectory()).absolute.path + "/documents";
//     file = "$dir";
//     print(LOGTAG+" FILE " + file);
//     File f = new File(file+"filename.csv");

// // convert rows to String and write as csv file

//     String csv = const ListToCsvConverter().convert(rows);
//     f.writeAsString(csv);
//   }

// }

  @override
  void initState() {
    allData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    final ref = fb.reference();
    return Scaffold(
        appBar: AppBar(
          title: Text("All Data Log"),
          actions: [
            IconButton(
                tooltip: "Refresh",
                onPressed: () {
                  allData();
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Column(
            children: [
              allRow.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          
                          label: Text(
                            'Time',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Temperature',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Humidity',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ], rows: allRow),
                    )
            ],
          )),
        ));
  }
}
