import 'package:dokuro_flutter/models/pie_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class PieChartSample3 extends StatefulWidget {
  const PieChartSample3({Key? key, required this.pies}) : super(key: key);

  final List<PieModel> pies;

  @override
  createState() => PieChartSample3State();
}

class PieChartSample3State extends State<PieChartSample3> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
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
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections()),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.pies.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      return PieChartSectionData(
        color: colors[i % colors.length],
        value: widget.pies[i].value,
        title: '${(widget.pies[i].value * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
        badgeWidget: _Badge(
          badges[i % badges.length],
          size: widgetSize,
          borderColor: colors[i % colors.length],
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  final Widget svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: svgAsset,
      ),
    );
  }
}

const List<Color> colors = [
  Color(0xff0293ee),
  Color(0xfff8b250),
  Color(0xff845bef),
  Color(0xff13d38e),
];

const List<Widget> badges = [
  Tooltip(
    message: 'Admin',
    child: Icon(Icons.rocket_launch, color: Colors.black),
  ),
  Tooltip(
    message: 'Shipper',
    child: Icon(Icons.delivery_dining, color: Colors.black),
  ),
  Tooltip(
    message: 'User',
    child: Icon(Icons.people, color: Colors.black),
  ),
];
