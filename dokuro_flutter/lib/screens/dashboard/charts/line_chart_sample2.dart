import 'package:dokuro_flutter/models/line_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({Key? key, required this.lineModel}) : super(key: key);

  final LineModel lineModel;

  @override
  createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              widget.lineModel.title,
              style: TextStyle(
                  fontSize: 12,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTitlesWidget: (value, _) {
            switch (value.toInt()) {
              case 0:
                return Text(widget.lineModel.x1);
              case 2:
                return Text(widget.lineModel.x3);
              case 5:
                return Text(widget.lineModel.x6);
              case 8:
                return Text(widget.lineModel.x9);
              case 11:
                return Text(widget.lineModel.x12);
            }
            return const Text('');
          },
        )),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) {
              switch (value.toInt()) {
                case 1:
                  return Text(widget.lineModel.y1);
                case 3:
                  return Text(widget.lineModel.y3);
                case 5:
                  return Text(widget.lineModel.y5);
              }
              return const Text('');
            },
            reservedSize: 32,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, widget.lineModel.lines[0].value1.toDouble()),
            FlSpot(1, widget.lineModel.lines[0].value2.toDouble()),
            FlSpot(2, widget.lineModel.lines[0].value3.toDouble()),
            FlSpot(3, widget.lineModel.lines[0].value4.toDouble()),
            FlSpot(4, widget.lineModel.lines[0].value5.toDouble()),
            FlSpot(5, widget.lineModel.lines[0].value6.toDouble()),
            FlSpot(6, widget.lineModel.lines[0].value7.toDouble()),
            FlSpot(7, widget.lineModel.lines[0].value8.toDouble()),
            FlSpot(8, widget.lineModel.lines[0].value9.toDouble()),
            FlSpot(9, widget.lineModel.lines[0].value10.toDouble()),
            FlSpot(10, widget.lineModel.lines[0].value11.toDouble()),
            FlSpot(11, widget.lineModel.lines[0].value12.toDouble()),
          ],
          color: gradientColors.first,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: gradientColors.first,
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: (value, _) {
            switch (value.toInt()) {
              case 2:
                return Text(widget.lineModel.x2);
              case 5:
                return Text(widget.lineModel.x5);
              case 8:
                return Text(widget.lineModel.x8);
            }
            return const Text('');
          },
          interval: 1,
        )),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              switch (value.toInt()) {
                case 1:
                  return Text(widget.lineModel.y1);
                case 3:
                  return Text(widget.lineModel.y3);
                case 5:
                  return Text(widget.lineModel.y5);
              }
              return const Text('');
            },
            reservedSize: 32,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, widget.lineModel.lines[0].value1.toDouble()),
            FlSpot(1, widget.lineModel.lines[0].value2.toDouble()),
            FlSpot(2, widget.lineModel.lines[0].value3.toDouble()),
            FlSpot(3, widget.lineModel.lines[0].value4.toDouble()),
            FlSpot(4, widget.lineModel.lines[0].value5.toDouble()),
            FlSpot(5, widget.lineModel.lines[0].value6.toDouble()),
            FlSpot(6, widget.lineModel.lines[0].value7.toDouble()),
            FlSpot(7, widget.lineModel.lines[0].value8.toDouble()),
            FlSpot(8, widget.lineModel.lines[0].value9.toDouble()),
            FlSpot(9, widget.lineModel.lines[0].value10.toDouble()),
            FlSpot(10, widget.lineModel.lines[0].value11.toDouble()),
            FlSpot(11, widget.lineModel.lines[0].value12.toDouble()),
          ],
          isCurved: true,
          color: ColorTween(begin: gradientColors[0], end: gradientColors[1])
              .lerp(0.2)!,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!
                .withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
