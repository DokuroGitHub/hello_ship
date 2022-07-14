import 'package:dokuro_flutter/models/pie_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({Key? key, required this.pies}) : super(key: key);

  final List<PieModel> pies;

  @override
  createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _indicatorItems(),
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _indicatorItems() {
    return List.generate(widget.pies.length, (i) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Indicator(
          color: colors[i % colors.length],
          text: widget.pies[i].title,
          isSquare: true,
        ),
      );
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.pies.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: widget.pies[i].value,
        title: '${(widget.pies[i].value * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}

const List<Color> colors = [
  Color(0xff0293ee),
  Color(0xfff8b250),
  Color(0xff845bef),
  Color(0xff13d38e),
];
