import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CustomCharts extends StatefulWidget {
  final double firstPart;
  final List<String> chartHumidity;
  final List<String> chartTime;
  
  CustomCharts({Key key, this.firstPart, this.chartHumidity, this.chartTime})
      : super(key: key);

  @override
  _CustomChartsState createState() => _CustomChartsState();
}

class _CustomChartsState extends State<CustomCharts> {
  List<String> chartDataHumidity = [];
  List<String> chartDataTime = [];
bool isLoad=true;
  @override
  void initState() {
    setState(() {
      print(widget.chartTime);
      print(widget.chartHumidity);
      chartDataHumidity = widget.chartHumidity;
      chartDataTime = widget.chartTime;
    });
    customSpots();
    super.initState();
  }

  List<FlSpot> plots = [];
  customSpots() {
    print("----------");
    print(chartDataTime.length);
    for (var i = 0; i < chartDataTime.length; i++) {
      setState(() {
        plots.add(FlSpot(double.parse(chartDataTime[i]),
            double.parse(chartDataHumidity[i])));
      });
    }
    print("------------");
    print(plots);
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isShowingMainData = true;

    Orientation mode = MediaQuery.of(context).orientation;
    double firstPart =
        mode == Orientation.landscape ? Get.height : Get.height * .4;
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Humidity , Moisture , Temperature',
                style: TextStyle(
                  fontFamily: "NunitoSans-semibold",
                  color: Color(0xff827daa),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(
              //   height: 1,
              // ),
              Text(
                'Overview',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Get.width * .1,
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
                  padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                  child: isLoad
                      ? CircularProgressIndicator()
                      : LineChart(
                          // isShowingMainData ?

                          sampleData1(),
                          // sampleData2(),

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
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
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
          rotateAngle: -90,
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            // switch (value.toInt()) {
            //   case 2:
            //     return 'SEPT';
            //   case 5:
            //     return 'OCT';
            //   case 12:
            //     return 'DEC';
            // }
            return '${chartDataHumidity[value.toInt()]}';
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
            // switch (value.toInt()) {
            //   case 1:
            //     return '1m';
            //   case 2:
            //     return '2m';
            //   case 3:
            //     return '3m';
            //   case 4:
            //     return '5m';
            // }
            return '${value.toInt()}';
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
      maxX: chartDataHumidity.length.toDouble(),
      maxY: chartDataHumidity.length.toDouble(),
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: plots,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    // final LineChartBarData lineChartBarData2 = LineChartBarData(
    //   spots: [
    //     FlSpot(1, 1),
    //     FlSpot(3, 2.8),
    //     FlSpot(7, 1.2),
    //     FlSpot(10, 2.8),
    //     FlSpot(12, 2.6),
    //     FlSpot(13, 3.9),
    //   ],
    //   isCurved: true,
    //   colors: [
    //     const Color(0xffaa4cfc),
    //   ],
    //   barWidth: 8,
    //   isStrokeCapRound: true,
    //   dotData: FlDotData(
    //     show: false,
    //   ),
    //   belowBarData: BarAreaData(show: false, colors: [
    //     const Color(0x00aa4cfc),
    //   ]),
    // );
    // final LineChartBarData lineChartBarData3 = LineChartBarData(
    //   spots: [
    //     FlSpot(1, 2.8),
    //     FlSpot(3, 1.9),
    //     FlSpot(6, 3),
    //     FlSpot(10, 1.3),
    //     FlSpot(13, 2.5),
    //   ],
    //   isCurved: true,
    //   colors: const [
    //     Color(0xff27b6fc),
    //   ],
    //   barWidth: 8,
    //   isStrokeCapRound: true,
    //   dotData: FlDotData(
    //     show: false,
    //   ),
    //   belowBarData: BarAreaData(
    //     show: false,
    //   ),
    // );
    return [
      lineChartBarData1,
      // lineChartBarData2,
      // lineChartBarData3,
    ];
  }
}

// LineChartData sampleData2() {
//   return LineChartData(
//     lineTouchData: LineTouchData(
//       enabled: false,
//     ),
//     gridData: FlGridData(
//       show: false,
//     ),
//     titlesData: FlTitlesData(
//       bottomTitles: SideTitles(
//         showTitles: true,
//         reservedSize: 22,
//         getTextStyles: (value) => const TextStyle(
//           color: Color(0xff72719b),
//           fontWeight: FontWeight.bold,
//           fontSize: 16,
//         ),
//         margin: 10,
//         getTitles: (value) {
//           switch (value.toInt()) {
//             case 2:
//               return 'SEPT';
//             case 7:
//               return 'OCT';
//             case 12:
//               return 'DEC';
//           }
//           return '';
//         },
//       ),
//       leftTitles: SideTitles(
//         showTitles: true,
//         getTextStyles: (value) => const TextStyle(
//           color: Color(0xff75729e),
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//         ),
//         getTitles: (value) {
//           switch (value.toInt()) {
//             case 1:
//               return '1m';
//             case 2:
//               return '2m';
//             case 3:
//               return '3m';
//             case 4:
//               return '5m';
//             case 5:
//               return '6m';
//           }
//           return '';
//         },
//         margin: 8,
//         reservedSize: 30,
//       ),
//     ),
//     borderData: FlBorderData(
//         show: true,
//         border: const Border(
//           bottom: BorderSide(
//             color: Color(0xff4e4965),
//             width: 4,
//           ),
//           left: BorderSide(
//             color: Colors.transparent,
//           ),
//           right: BorderSide(
//             color: Colors.transparent,
//           ),
//           top: BorderSide(
//             color: Colors.transparent,
//           ),
//         )),
//     minX: 0,
//     maxX: 14,
//     maxY: 6,
//     minY: 0,
//     // lineBarsData: linesBarData2(),
//   );
// }

// List<LineChartBarData> linesBarData2() {
//   return [
//     LineChartBarData(
//       spots: [
//         FlSpot(1, 1),
//         FlSpot(3, 4),
//         FlSpot(5, 1.8),
//         FlSpot(7, 5),
//         FlSpot(10, 2),
//         FlSpot(12, 2.2),
//         FlSpot(13, 1.8),
//       ],
//       isCurved: true,
//       curveSmoothness: 0,
//       colors: const [
//         Color(0x444af699),
//       ],
//       barWidth: 4,
//       isStrokeCapRound: true,
//       dotData: FlDotData(
//         show: false,
//       ),
//       belowBarData: BarAreaData(
//         show: false,
//       ),
//     ),
//     LineChartBarData(
//       spots: [
//         FlSpot(1, 1),
//         FlSpot(3, 2.8),
//         FlSpot(7, 1.2),
//         FlSpot(10, 2.8),
//         FlSpot(12, 2.6),
//         FlSpot(13, 3.9),
//       ],
//       isCurved: true,
//       colors: const [
//         Color(0x99aa4cfc),
//       ],
//       barWidth: 4,
//       isStrokeCapRound: true,
//       dotData: FlDotData(
//         show: false,
//       ),
//       belowBarData: BarAreaData(show: true, colors: [
//         const Color(0x33aa4cfc),
//       ]),
//     ),
//     LineChartBarData(
//       spots: [
//         FlSpot(1, 3.8),
//         FlSpot(3, 1.9),
//         FlSpot(6, 5),
//         FlSpot(10, 3.3),
//         FlSpot(13, 4.5),
//       ],
//       isCurved: true,
//       curveSmoothness: 0,
//       colors: const [
//         Color(0x4427b6fc),
//       ],
//       barWidth: 2,
//       isStrokeCapRound: true,
//       dotData: FlDotData(show: true),
//       belowBarData: BarAreaData(
//         show: false,
//       ),
//     ),
//   ];
// }
