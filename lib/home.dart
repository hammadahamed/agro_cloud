import 'dart:async';
import 'package:agro_cloud/soilMoisture.dart';
import 'package:agro_cloud/temperatureLog.dart';
import 'package:agro_cloud/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:agro_cloud/utils.Dart';
import 'datasTable.dart';
import 'package:agro_cloud/controls.dart';

import 'humidityLog.dart';

class Home extends StatefulWidget {
  final GoogleSignInAccount detailsUser;
  final bool guest;
  Home({Key key, this.detailsUser, this.guest}) : super(key: key);
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with TickerProviderStateMixin {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final fb = FirebaseDatabase.instance;
  bool isLiveState = false;
  bool isDark = Get.isDarkMode;

  bool isShowingMainData;

  isLive() {
    final re = fb.reference();

    re.child("TimeStamp").once().then((DataSnapshot data) {
      int diff = 0;
      String time = data.value;
      List<String> splitted = time.split(RegExp(r"[T,+]"));

      String currTime =
          new DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

      DateTime nowTime = DateTime.parse(currTime);
      DateTime lastTime = DateTime.parse(splitted[0] + ' ' + splitted[1]);
      diff = nowTime.difference(lastTime).inSeconds;

      if (diff > 8) {
        setState(() {
          isLiveState = false;
        });
      } else
        setState(() {
          isLiveState = true;
        });
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      isLive();
    });
    isShowingMainData = true;
  }

  Widget oneThirdContainer({Widget content}) {
    return Container(
      width: Get.width / 4,
      child: content,
    );
  }

  cardContainer({child}) {
    return Container(
      height: (Get.height * .3) / 3,
      width: Get.width,
      child: child,
    );
  }

  Widget chipContainer({child}) {
    return Container(
      width: isLiveState ? 75 : 150,
      height: 25,
      margin: EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color(0xff46426c),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [child],
      ),
    );
  }

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
    final ref = fb.reference();

    Orientation mode = MediaQuery.of(context).orientation;
    double firstPart =
        mode == Orientation.landscape ? Get.height : Get.height * .4;
    double secondPart =
        mode == Orientation.landscape ? Get.height : Get.height * .3;

    return SafeArea(
      child: Scaffold(
          // DRAWER
          drawer: Drawer(
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
                        child: Container(
                          width: Get.width / 3,
                          child: Text(
                            widget.guest
                                ? " Welcome \nGuest,\n"
                                : " Welcome" + widget.detailsUser.toString(),
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
                          Get.to(Controls());
                        }),

                    sideTile(
                        title: "Humidity log",
                        function: () {
                          Navigator.pop(context);
                          Get.to(HumidityLog());
                        }),
                    sideTile(
                        title: "Temperature log",
                        function: () {
                          Navigator.pop(context);
                          Get.to(TemperatureLog());
                        }),
                    sideTile(
                        title: "Soil Moisture log",
                        function: () {
                          Navigator.pop(context);
                          Get.to(SoilMoistureLog());
                        }),
                    sideTile(
                        title: "Export",
                        function: () {
                          Navigator.pop(context);
                          Get.to(DatasTable());
                        }),
                  ],
                ),
              ),
            ),
          ),

          // APPBAR
          appBar: AppBar(
            iconTheme: IconThemeData(color: MyColors.primaryColor),
            backgroundColor: Get.isDarkMode ? null : Colors.white,
            title: Text(
              "Agro Cloud",
              style: TextStyle(
                  fontFamily: "NunitoSans-semibold",
                  color: Get.isDarkMode ? Colors.white : MyColors.primaryColor),
            ),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => User(
                        userdetails: widget.detailsUser,
                        guest: widget.guest,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: "avatar",
                    child: CircleAvatar(
                      backgroundColor:
                          widget.guest ? MyColors.primaryColor : null,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      radius: 20.0,
                      backgroundImage: widget.guest
                          ? null
                          : NetworkImage(widget.detailsUser.photoUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //  ACTUAL BODY
          body: StreamBuilder(
            stream: ref.onValue,
            builder: (context, snap) {
              return snap.data == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // CHART
                          Container(
                            height: firstPart,
                            // margin:
                            //     EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: const BoxDecoration(
                              // borderRadius:
                              //     BorderRadius.all(Radius.circular(3)),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff2c274c),
                                  Color(0xff46426c),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 37,
                                    ),
                                    const Text(
                                      'Humidity , Moisture , Temperature',
                                      style: TextStyle(
                                        fontFamily: "NunitoSans-semibold",
                                        color: Color(0xff827daa),
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Overview',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Get.width * .15,
                                          fontFamily: "NunitoSans-regular",
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 37,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0, left: 6.0),
                                        child: LineChart(
                                          isShowingMainData
                                              ? sampleData1()
                                              : sampleData2(),
                                          swapAnimationDuration:
                                              const Duration(milliseconds: 250),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.white.withOpacity(
                                        isShowingMainData ? 1.0 : 0.5),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isShowingMainData = !isShowingMainData;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),

                          // MODULE CONNECTION STATUS
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  " CONNECTION  STATUS",
                                  style: TextStyle(
                                      fontSize: Get.width * .04,
                                      color:Get.isDarkMode?Colors.blueGrey[200]:Colors.black54,
                                      fontFamily: "NunitoSans-semibold"),
                                ),
                                isLiveState
                                    ? chipContainer(
                                        child: FadeTransition(
                                          opacity: CurvedAnimation(
                                              parent: AnimationController(
                                                duration: const Duration(
                                                    milliseconds: 750),
                                                vsync: this,
                                              )..repeat(reverse: true),
                                              curve: Curves.easeIn),
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  maxRadius: 5,
                                                ),
                                              ),
                                              Text(
                                                "Live",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      )
                                    : chipContainer(
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                maxRadius: 5,
                                              ),
                                            ),
                                            Text(
                                              "Disconnected",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Get.width * .03,
                                                  fontFamily:
                                                      "NunitoSans-regular",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          // ListTile(
                          //   title: Text("Time Stamp"),
                          //   trailing: Text(snap.data.snapshot.value["TimeStamp"]
                          //       .toString()),
                          // ),
                          SizedBox(height: 20),

                          // TILES
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: secondPart,
                            // color: MyColors.primaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                cardContainer(
                                    child: Card(
                                        child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Hero(
                                            tag: "HumIcon",
                                            child: Image(
                                              height: 30,
                                              image: AssetImage(
                                                'assets/photo/humidity.png',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          oneThirdContainer(
                                            content: Text(
                                              "HUMIDITY",
                                              style: TextStyle(
                                                  fontFamily: "NunitoSans-bold",
                                                  fontSize: Get.width * .033),
                                            ),
                                          ),
                                        ],
                                      ),
                                      oneThirdContainer(
                                        content: Text(
                                          snap.data.snapshot
                                              .value["DHT11Humidity"],
                                          style: TextStyle(
                                              // fontFamily: "NunitoSans-semibold",
                                              fontSize: Get.width * .07,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.cyan),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.chevron_right),
                                        onPressed: () {
                                          Get.to(HumidityLog());
                                        },
                                      )
                                    ],
                                  ),
                                ))),
                                cardContainer(
                                  child: Card(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Hero(
                                                tag: "ThermoIcon",
                                                child: SvgPicture.asset(
                                                  'assets/icons/thermometer.svg',
                                                  height: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              oneThirdContainer(
                                                content: Text(
                                                  "TEMPERATURE",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "NunitoSans-bold",
                                                    fontSize: Get.width * .033,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          oneThirdContainer(
                                            content: Text(
                                              snap.data.snapshot
                                                  .value["DHT11Temperature"],
                                              style: TextStyle(
                                                  fontSize: Get.width * .07,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.chevron_right),
                                            onPressed: () {
                                              Get.to(TemperatureLog());
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                cardContainer(
                                  child: Card(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Hero(
                                                tag: "SoilMoisIcon",
                                                child: Image.asset(
                                                  'assets/photo/soilmoisture.png',
                                                  height: 45,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              oneThirdContainer(
                                                content: Text(
                                                  "SOIL MOISTURE",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "NunitoSans-bold",
                                                      fontSize:
                                                          Get.width * .033),
                                                ),
                                              ),
                                            ],
                                          ),
                                          oneThirdContainer(
                                            content: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: Text(
                                                "30%",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.yellow[700],
                                                    fontSize: Get.width * .075),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.chevron_right),
                                            onPressed: () {
                                              Get.to(SoilMoistureLog());
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //         context,
                          //         new MaterialPageRoute(
                          //             builder: (context) => DatasTable()));
                          //   },
                          //   child: Text("All Data"),
                          // ),
                        ],
                      ),
                    );
            },
          )),
    );
  }
}

LineChartData sampleData1() {
  return LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
      touchCallback: (LineTouchResponse touchResponse) {},
      handleBuiltInTouches: true,
    ),
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 10,
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'SEPT';
            case 7:
              return 'OCT';
            case 12:
              return 'DEC';
          }
          return '';
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '1m';
            case 2:
              return '2m';
            case 3:
              return '3m';
            case 4:
              return '5m';
          }
          return '';
        },
        margin: 8,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(
          color: Color(0xff4e4965),
          width: 4,
        ),
        left: BorderSide(
          color: Colors.transparent,
        ),
        right: BorderSide(
          color: Colors.transparent,
        ),
        top: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
    lineBarsData: linesBarData1(),
  );
}

List<LineChartBarData> linesBarData1() {
  final LineChartBarData lineChartBarData1 = LineChartBarData(
    spots: [
      FlSpot(1, 1),
      FlSpot(3, 1.5),
      FlSpot(5, 1.4),
      FlSpot(7, 3.4),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ],
    isCurved: true,
    colors: [
      const Color(0xff4af699),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData lineChartBarData2 = LineChartBarData(
    spots: [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
    isCurved: true,
    colors: [
      const Color(0xffaa4cfc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(show: false, colors: [
      const Color(0x00aa4cfc),
    ]),
  );
  final LineChartBarData lineChartBarData3 = LineChartBarData(
    spots: [
      FlSpot(1, 2.8),
      FlSpot(3, 1.9),
      FlSpot(6, 3),
      FlSpot(10, 1.3),
      FlSpot(13, 2.5),
    ],
    isCurved: true,
    colors: const [
      Color(0xff27b6fc),
    ],
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  return [
    lineChartBarData1,
    lineChartBarData2,
    lineChartBarData3,
  ];
}

LineChartData sampleData2() {
  return LineChartData(
    lineTouchData: LineTouchData(
      enabled: false,
    ),
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        margin: 10,
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'SEPT';
            case 7:
              return 'OCT';
            case 12:
              return 'DEC';
          }
          return '';
        },
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return '1m';
            case 2:
              return '2m';
            case 3:
              return '3m';
            case 4:
              return '5m';
            case 5:
              return '6m';
          }
          return '';
        },
        margin: 8,
        reservedSize: 30,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        )),
    minX: 0,
    maxX: 14,
    maxY: 6,
    minY: 0,
    lineBarsData: linesBarData2(),
  );
}

List<LineChartBarData> linesBarData2() {
  return [
    LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 4),
        FlSpot(5, 1.8),
        FlSpot(7, 5),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: const [
        Color(0x444af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
    LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: const [
        Color(0x99aa4cfc),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: true, colors: [
        const Color(0x33aa4cfc),
      ]),
    ),
    LineChartBarData(
      spots: [
        FlSpot(1, 3.8),
        FlSpot(3, 1.9),
        FlSpot(6, 5),
        FlSpot(10, 3.3),
        FlSpot(13, 4.5),
      ],
      isCurved: true,
      curveSmoothness: 0,
      colors: const [
        Color(0x4427b6fc),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(
        show: false,
      ),
    ),
  ];
}
