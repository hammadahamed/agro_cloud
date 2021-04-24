import 'package:agro_cloud/components/custom_charts.dart';
import 'package:flutter/material.dart';
import 'package:agro_cloud/controller/data_controller.dart';
import 'package:get/get.dart';
class DummyChartPage extends StatefulWidget {

  
  @override
  _DummyChartPageState createState() => _DummyChartPageState();
}

class _DummyChartPageState extends State<DummyChartPage> {
  DataController dataController = Get.find();

  @override
  void initState() {
    dataController.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body:CustomCharts()
    );
  }
}