import 'package:dokuro_flutter/models/line_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData, required this.lineModel});

  final LineModel lineModel;
  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1(),
        minX: 0,
        maxX: 11,
        maxY: 4,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2(),
        minX: 0,
        maxX: 11,
        maxY: 5,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: leftTitles(
          getTitlesWidget: (value, _) {
            switch (value.toInt()) {
              case 1:
                return Text(lineModel.y1);
              case 2:
                return Text(lineModel.y2);
              case 3:
                return Text(lineModel.y3);
              case 4:
                return Text(lineModel.y4);
            }
            return const Text('');
          },
        )),
      );

  static List<Color> lineBarsData1Colors = [
    const Color(0xff4af699),
    const Color(0xffaa4cfc),
    const Color(0xff27b6fc),
  ];

  static List<Color> lineBarsData2Colors = [
    const Color(0x444af699),
    const Color(0x99aa4cfc),
    const Color(0x4427b6fc)
  ];

  List<LineChartBarData> lineBarsData1() {
    List<LineChartBarData> listLineChartBarData = [];
    for (int i = 0; i < lineModel.lines.length; i++) {
      LineChartBarData lineChartBarData = LineChartBarData(
        isCurved: true,
        color: lineBarsData1Colors[i % lineBarsData1Colors.length],
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
            show: false,
            color: lineBarsData1Colors[i % lineBarsData1Colors.length]),
        spots: [
          FlSpot(0, lineModel.lines[i].value1.toDouble()),
          FlSpot(1, lineModel.lines[i].value2.toDouble()),
          FlSpot(2, lineModel.lines[i].value3.toDouble()),
          FlSpot(3, lineModel.lines[i].value4.toDouble()),
          FlSpot(4, lineModel.lines[i].value5.toDouble()),
          FlSpot(5, lineModel.lines[i].value6.toDouble()),
          FlSpot(6, lineModel.lines[i].value7.toDouble()),
          FlSpot(7, lineModel.lines[i].value8.toDouble()),
          FlSpot(8, lineModel.lines[i].value9.toDouble()),
          FlSpot(9, lineModel.lines[i].value10.toDouble()),
          FlSpot(10, lineModel.lines[i].value11.toDouble()),
          FlSpot(11, lineModel.lines[i].value12.toDouble()),
        ],
      );
      listLineChartBarData.add(lineChartBarData);
    }

    return listLineChartBarData;
  }

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: leftTitles(
          getTitlesWidget: (value, _) {
            switch (value.toInt()) {
              case 1:
                return Text(lineModel.y1);
              case 2:
                return Text(lineModel.y2);
              case 3:
                return Text(lineModel.y3);
              case 4:
                return Text(lineModel.y4);
              case 5:
                return Text(lineModel.y5);
            }
            return const Text('');
          },
        )),
      );

  List<LineChartBarData> lineBarsData2() {
    List<LineChartBarData> listLineChartBarData = [];
    for (int i = 0; i < lineModel.lines.length; i++) {
      LineChartBarData lineChartBarData = LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: lineBarsData2Colors[i % lineBarsData2Colors.length],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(0, lineModel.lines[i].value1.toDouble()),
          FlSpot(1, lineModel.lines[i].value2.toDouble()),
          FlSpot(2, lineModel.lines[i].value3.toDouble()),
          FlSpot(3, lineModel.lines[i].value4.toDouble()),
          FlSpot(4, lineModel.lines[i].value5.toDouble()),
          FlSpot(5, lineModel.lines[i].value6.toDouble()),
          FlSpot(6, lineModel.lines[i].value7.toDouble()),
          FlSpot(7, lineModel.lines[i].value8.toDouble()),
          FlSpot(8, lineModel.lines[i].value9.toDouble()),
          FlSpot(9, lineModel.lines[i].value10.toDouble()),
          FlSpot(10, lineModel.lines[i].value11.toDouble()),
          FlSpot(11, lineModel.lines[i].value12.toDouble()),
        ],
      );
      listLineChartBarData.add(lineChartBarData);
    }

    return listLineChartBarData;
  }

  SideTitles leftTitles(
          {required Widget Function(double, TitleMeta)? getTitlesWidget}) =>
      SideTitles(
        getTitlesWidget: getTitlesWidget,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        interval: 1,
        getTitlesWidget: (value, _) {
          switch (value.toInt()) {
            case 1:
              return Text(lineModel.x2);
            case 6:
              return Text(lineModel.x7);
            case 11:
              return Text(lineModel.x12);
          }
          return const Text('');
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({Key? key, required this.lineModel}) : super(key: key);

  final LineModel lineModel;

  @override
  createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                const Text(
                  'Thống kê người dùng',
                  style: TextStyle(
                    color: Color(0xff827daa),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.lineModel.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: _LineChart(
                        lineModel: widget.lineModel,
                        isShowingMainData: isShowingMainData),
                  ),
                ),
                const SizedBox(height: 5),
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
      ),
    );
  }
}
