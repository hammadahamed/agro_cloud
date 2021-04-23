import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:simple_permissions/simple_permissions.dart';
getPerm() async {
  Map<Permission, PermissionStatus> statuses = await [
    // Permission.location,
    Permission.storage,
  ].request();
  return statuses;
}

allCsv(List<String> date, List<String> time, List<String> temperature,
    List<String> humidity,List<String> soilmoisture) async {
  String file;
  // String dir;
  //create an element rows of type list of list. All the above data set are stored in associate list
  //Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.
  List<List<dynamic>> rows = [
    ["Date", "Time", "Temperature", "Humidity", "Soil Moisture"]
  ];
  for (int i = 0; i < time.length; i++) {
    //row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = [];
    row.add(date[i]);
    row.add(time[i]);
    row.add(temperature[i]);
    row.add(humidity[i]);
    row.add(soilmoisture[i]);
    rows.add(row);
  }
  Map<Permission, PermissionStatus> variable = await getPerm();
  
  if (variable[Permission.storage] == PermissionStatus.denied) {
    Get.snackbar("Failed", "please get permission",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
    return;
  // We didn't ask for permission yet or the permission has been denied before but not permanently.
  }
//You can can also directly ask the permission about its status.
  if (await Permission.storage.isRestricted) {
    Get.snackbar("Failed", "please Change in Settings",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
    return;
  // The OS restricts access, for example because of parental controls.
  }
  //PermissionStatus permissionResult = await SimplePermissions.requestPermission(
  //Permission.WriteExternalStorage);
  if (await Permission.storage.isGranted) {
    //store file in documents folder
    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/";
    file = "$dir";
    print(" FILE " + file);
    File f = new File(file + "AllData.csv");
    // convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    Get.snackbar("Success", "Data Exported Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
  }
}

humidityCsv(List<String> date, List<String> time, List<String> humidity) async {
  String file;
  // String dir;
  //create an element rows of type list of list. All the above data set are stored in associate list
  //Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.
  List<List<dynamic>> rows = [
    ["Date", "Time", "Humidity"]
  ];
  for (int i = 0; i < time.length; i++) {
    //row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = [];
    row.add(date[i]);
    row.add(time[i]);
    row.add(humidity[i]);
    rows.add(row);
  }
  Map<Permission, PermissionStatus> variable = await getPerm();

  if (variable[Permission.storage] == PermissionStatus.denied) {
    Get.snackbar("Failed", "please get permission",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
    return;
  // We didn't ask for permission yet or the permission has been denied before but not permanently.
  }
//You can can also directly ask the permission about its status.
  if (await Permission.storage.isRestricted) {
    Get.snackbar("Failed", "please Change in Settings",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
    return;
  // The OS restricts access, for example because of parental controls.
  }
  //PermissionStatus permissionResult = await SimplePermissions.requestPermission(
  //Permission.WriteExternalStorage);
  if (await Permission.storage.isGranted) {
    //store file in documents folder
    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/";
    file = "$dir";
    print(" FILE " + file);
    File f = new File(file + "HumidityExport.csv");
    // convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    Get.snackbar("Success", "Data Exported Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
  }
}


temperatureCsv(List<String> date, List<String> time, List<String> temperature) async {
  String file;
  // String dir;
  //create an element rows of type list of list. All the above data set are stored in associate list
  //Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.
  List<List<dynamic>> rows = [
    ["Date", "Time", "Temperature"]
  ];
  for (int i = 0; i < time.length; i++) {
    //row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = [];
    row.add(date[i]);
    row.add(time[i]);
    row.add(temperature[i]);
    rows.add(row);
  }
  Map<Permission, PermissionStatus> variable = await getPerm();

  if (variable[Permission.storage] == PermissionStatus.denied) {
    Get.snackbar("Failed", "please get permission",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
    return;
  // We didn't ask for permission yet or the permission has been denied before but not permanently.
  }
//You can can also directly ask the permission about its status.
  if (await Permission.storage.isRestricted) {
    Get.snackbar("Failed", "please Change in Settings",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
    return;
  // The OS restricts access, for example because of parental controls.
  }
  //PermissionStatus permissionResult = await SimplePermissions.requestPermission(
  //Permission.WriteExternalStorage);
  if (await Permission.storage.isGranted) {
    //store file in documents folder
    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/";
    file = "$dir";
    print(" FILE " + file);
    File f = new File(file + "TemperatureExport.csv");
    // convert rows to String and write as csv file
    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
    Get.snackbar("Success", "Data Exported Successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        dismissDirection: SnackDismissDirection.HORIZONTAL);
  }
}
