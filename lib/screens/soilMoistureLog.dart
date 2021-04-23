import 'package:flutter/material.dart';
import 'package:agro_cloud/utils.Dart';
import 'package:get/get.dart';

class SoilMoistureLog extends StatefulWidget {
  @override
  _SoilMoistureLogState createState() => _SoilMoistureLogState();
}

class _SoilMoistureLogState extends State<SoilMoistureLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: MyColors.primaryColor),
        title: Text(
          "Soil Moisture Logs",
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
                onPressed: null,
              ),
              IconButton(
                  tooltip: "Refresh",
                  icon: Icon(Icons.refresh),
                  onPressed: null),
            ],
          )
        ],
      ),
      body: Center(
        child: Text("No Data available"),
      ),
    );
  }
}
