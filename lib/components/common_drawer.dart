import 'package:agro_cloud/screens/controls.dart';
import 'package:agro_cloud/screens/datasTable.dart';
import 'package:agro_cloud/screens/humidityLog.dart';
import 'package:agro_cloud/screens/soilMoistureLog.dart';
import 'package:agro_cloud/screens/temperatureLog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonDrawer extends StatelessWidget {
  final isGuest, userDetails;
  const CommonDrawer({Key key, this.isGuest, this.userDetails})
      : super(key: key);
  Widget sideTile({String title, function}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontFamily: "NunitoSans-regular"),
      ),
      onTap: function,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // USER BANNER
              Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.8), BlendMode.dstATop),
                        image: AssetImage(
                          'assets/photo/black_abstract.jpg',
                        ),
                        fit: BoxFit.cover)),
                height: Get.height / 4,
                width: double.maxFinite,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: Get.width / 3,
                    child: Text(
                      isGuest
                          ? " Welcome \nGuest,\n"
                          : " Welcome" + userDetails.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Get.width * .075,
                          fontFamily: "NunitoSans-regular"),
                    ),
                  ),
                ),
              ),
              // NAVIGATIONS
              sideTile(
                  title: "Overview",
                  function: () {
                    Navigator.pop(context);
                  }),
              sideTile(
                  title: "Analytics",
                  function: () {
                    print("==========");
                  }),
              sideTile(
                  title: "Controls",
                  function: () {
                    // print("==========");
                    Navigator.pop(context);
                    Get.to(() => Controls());
                  }),

              sideTile(
                  title: "Humidity log",
                  function: () {
                    Navigator.pop(context);
                    Get.to(() => HumidityLog());
                  }),
              sideTile(
                  title: "Temperature log",
                  function: () {
                    Navigator.pop(context);
                    Get.to(() => TemperatureLog());
                  }),
              sideTile(
                  title: "Soil Moisture log",
                  function: () {
                    Navigator.pop(context);
                    Get.to(() => SoilMoistureLog());
                  }),
              sideTile(
                  title: "Export",
                  function: () {
                    Navigator.pop(context);
                    Get.to(() => DatasTable());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
