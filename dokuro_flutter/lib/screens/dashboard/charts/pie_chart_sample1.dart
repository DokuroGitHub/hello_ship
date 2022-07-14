import 'package:dokuro_flutter/models/pie_model.dart';
import 'package:dokuro_flutter/screens/dashboard/charts/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({Key? key, required this.pies}) : super(key: key);

  final List<PieModel> pies;

  @override
  createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 28),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _indicatorItem(),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(PieChartData(
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections: showingSections(),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _indicatorItem() {
    return List.generate(
      widget.pies.length,
      (i) {
        return Indicator(
          color: colors[i % colors.length],
          text: widget.pies[i].title,
          isSquare: false,
          size: touchedIndex == i ? 18 : 16,
          textColor: touchedIndex == i ? Colors.black : Colors.grey,
        );
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      widget.pies.length,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        return PieChartSectionData(
          color: colors[i % colors.length].withOpacity(opacity),
          value: widget.pies[i].value,
          title: widget.pies[i].count.toString(),
          radius: 80,
          titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: titleColors[i % titleColors.length]),
          titlePositionPercentageOffset: 0.55,
          borderSide: isTouched
              ? BorderSide(color: colors[i % colors.length], width: 6)
              : BorderSide(color: colors[i % colors.length].withOpacity(0)),
        );
      },
    );
  }
}

const List<Color> colors = [
  Color(0xff0293ee),
  Color(0xfff8b250),
  Color(0xff845bef),
  Color(0xff13d38e),
];

const List<Color> titleColors = [
  Color(0xff044d7c),
  Color(0xff90672d),
  Color(0xff4c3788),
  Color(0xff0c7f55),
];
