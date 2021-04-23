import 'package:agro_cloud/controller/auth_controller.dart';
import 'package:agro_cloud/home.dart';
import 'package:agro_cloud/screens/controls.dart';
import 'package:agro_cloud/screens/datasTable.dart';
import 'package:agro_cloud/screens/humidityLog.dart';
import 'package:agro_cloud/screens/soilMoistureLog.dart';
import 'package:agro_cloud/screens/temperatureLog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonDrawer extends StatefulWidget {
  CommonDrawer({Key key}) : super(key: key);

  @override
  _CommonDrawerState createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  final AuthController auth = Get.find();

  var user;

  Widget sideTile({String title, function, IconData icon, Color iconColor}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontFamily: "NunitoSans-regular"),
      ),
      horizontalTitleGap: 1,
      leading: Icon(
        icon,
        color: iconColor,
        size: 20,
      ),
      onTap: function,
    );
  }

  @override
  void initState() {
    user = auth.userObj;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: Get.height,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // NAVIGATIONS
            Container(
              height: Get.height * .8,
              child: Column(
                children: [
                  // USER BANNER
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.8),
                                BlendMode.dstATop),
                            image: AssetImage(
                              'assets/photo/black_abstract.jpg',
                            ),
                            fit: BoxFit.cover)),
                    height: Get.height / 4,
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome,",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Get.width * .07,
                                  fontFamily: "NunitoSans-regular"),
                            ),
                            Text(
                              user == null ? "Guest,\n" : user.displayName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Get.width * .07,
                                  fontFamily: "NunitoSans-regular"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  sideTile(
                      title: "Overview",
                      icon: Icons.pie_chart,
                      iconColor: Colors.yellow[700],
                      function: () {
                        Navigator.pop(context);
                        Get.offAll(() => Home());
                      }),
                  sideTile(
                      title: "Analytics",
                      icon: Icons.bar_chart_outlined,
                      iconColor: Colors.pink,
                      function: () {
                        print("==========");
                      }),
                  sideTile(
                      title: "Controls",
                      icon: Icons.settings,
                      function: () {
                        // print("==========");
                        Navigator.pop(context);
                        Get.to(() => Controls());
                      }),
                  sideTile(
                      title: "Humidity log",
                      icon: Icons.ac_unit_outlined,
                      iconColor: Colors.lightBlue[200],
                      function: () {
                        Navigator.pop(context);
                        Get.to(() => HumidityLog());
                      }),
                  sideTile(
                      title: "Temperature log",
                      icon: Icons.thermostat_outlined,
                      iconColor: Colors.orange,
                      function: () {
                        Navigator.pop(context);
                        Get.to(() => TemperatureLog());
                      }),
                  sideTile(
                      title: "Soil Moisture log",
                      icon: Icons.add_chart,
                      iconColor: Colors.brown,
                      function: () {
                        Navigator.pop(context);
                        Get.to(() => SoilMoistureLog());
                      }),
                  sideTile(
                      title: "Export",
                      icon: Icons.launch_rounded,
                      iconColor: Colors.purple,
                      function: () {
                        Navigator.pop(context);
                        Get.to(() => DatasTable());
                      }),
                ],
              ),
            ),

            user != null
                ? sideTile(
                    title: "Logout",
                    icon: Icons.power_settings_new_outlined,
                    function: () {
                      auth.googleSignIn.signOut();
                      Get.off(() => Home());
                    })
                : sideTile(
                    title: "Login",
                    icon: Icons.login,
                    function: () {
                      auth.signIn();
                    }),
          ],
        ),
      ),
    );
  }
}
