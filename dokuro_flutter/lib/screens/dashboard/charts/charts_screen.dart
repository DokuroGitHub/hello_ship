import 'package:dokuro_flutter/controllers/dashboard/charts_controller.dart';
import 'package:dokuro_flutter/models/line_model.dart';
import 'package:dokuro_flutter/models/pie_model.dart';
import 'package:dokuro_flutter/screens/dashboard/charts/line_chart_sample1.dart';
import 'package:dokuro_flutter/screens/dashboard/charts/line_chart_sample2.dart';
import 'package:dokuro_flutter/screens/dashboard/charts/pie_chart_sample1.dart';
import 'package:dokuro_flutter/screens/dashboard/charts/pie_chart_sample2.dart';
import 'package:dokuro_flutter/screens/dashboard/charts/pie_chart_sample3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_moment/simple_moment.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({Key? key}) : super(key: key);

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final chartsController = ChartsController();

  @override
  void initState() {
    chartsController.initPlz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    return Scaffold(
      appBar: _appBar(context),
      body: PageView(
        controller: chartsController.pageController,
        onPageChanged: (page) {
          chartsController.currentPage.value = page;
        },
        children: [
          _page1(),
          _page2(),
        ],
      ),
      floatingActionButton: _fab(),
    );
  }

  Widget _fab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 16, 16, 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Visibility(
                visible: chartsController.currentPage.value != 0,
                child: FloatingActionButton(
                  onPressed: chartsController.onPreviousPageTap,
                  mini: true,
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.chevron_left_rounded),
                ),
              )),
          Obx(() => Visibility(
                visible: chartsController.currentPage.value != 1,
                child: FloatingActionButton(
                  onPressed: chartsController.onNextPageTap,
                  mini: true,
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.chevron_right_rounded),
                ),
              )),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title:
          Text('Charts', style: Theme.of(context).appBarTheme.titleTextStyle),
    );
  }

  Widget _page1() {
    return Container(
      color: const Color(0xff262545),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 36.0,
              top: 24,
            ),
            child: Text(
              'Line Chart',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => _buildCharts()),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _page2() {
    return ListView(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Pie Chart',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => _buildPieCharts()),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildPieCharts() {
    final sum = chartsController.countAdmins.value +
        chartsController.countShippers.value +
        chartsController.countUsers.value;
    if (sum == 0) {
      return const Text('No data');
    }
    if (1 == 1) {
      List<PieModel> pies = [];
      pies.add(PieModel(
        title: 'Admin',
        count: chartsController.countAdmins.value,
        value: chartsController.countAdmins.value / sum,
      ));
      pies.add(PieModel(
        title: 'Shipper',
        count: chartsController.countShippers.value,
        value: chartsController.countShippers.value / sum,
      ));
      pies.add(PieModel(
        title: 'User',
        count: chartsController.countUsers.value,
        value: chartsController.countUsers.value / sum,
      ));

      return Column(
        children: [
          PieChartSample1(pies: pies),
          const SizedBox(
            height: 12,
          ),
          PieChartSample2(pies: pies),
          const SizedBox(
            height: 12,
          ),
          PieChartSample3(pies: pies),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildCharts() {
    List<Line> lines = [];

    Line lineAdmin = Line(
      title: 'Admin',
      value1: chartsController.monthFrom11To12Admin.value,
      value2: chartsController.monthFrom10To11Admin.value,
      value3: chartsController.monthFrom9To10Admin.value,
      value4: chartsController.monthFrom8To9Admin.value,
      value5: chartsController.monthFrom7To8Admin.value,
      value6: chartsController.monthFrom6To7Admin.value,
      value7: chartsController.monthFrom5To6Admin.value,
      value8: chartsController.monthFrom4To5Admin.value,
      value9: chartsController.monthFrom3To4Admin.value,
      value10: chartsController.monthFrom2To3Admin.value,
      value11: chartsController.monthFrom1To2Admin.value,
      value12: chartsController.monthFrom0To1Admin.value,
    );
    Line lineShipper = Line(
      title: 'Shipper',
      value1: chartsController.monthFrom11To12Shipper.value,
      value2: chartsController.monthFrom10To11Shipper.value,
      value3: chartsController.monthFrom9To10Shipper.value,
      value4: chartsController.monthFrom8To9Shipper.value,
      value5: chartsController.monthFrom7To8Shipper.value,
      value6: chartsController.monthFrom6To7Shipper.value,
      value7: chartsController.monthFrom5To6Shipper.value,
      value8: chartsController.monthFrom4To5Shipper.value,
      value9: chartsController.monthFrom3To4Shipper.value,
      value10: chartsController.monthFrom2To3Shipper.value,
      value11: chartsController.monthFrom1To2Shipper.value,
      value12: chartsController.monthFrom0To1Shipper.value,
    );
    Line lineUser = Line(
      title: 'User',
      value1: chartsController.monthFrom11To12User.value,
      value2: chartsController.monthFrom10To11User.value,
      value3: chartsController.monthFrom9To10User.value,
      value4: chartsController.monthFrom8To9User.value,
      value5: chartsController.monthFrom7To8User.value,
      value6: chartsController.monthFrom6To7User.value,
      value7: chartsController.monthFrom5To6User.value,
      value8: chartsController.monthFrom4To5User.value,
      value9: chartsController.monthFrom3To4User.value,
      value10: chartsController.monthFrom2To3User.value,
      value11: chartsController.monthFrom1To2User.value,
      value12: chartsController.monthFrom0To1User.value,
    );

    lines.add(lineAdmin);
    lines.add(lineShipper);
    lines.add(lineUser);

    int maxY = 0;
    for (int i = 0; i < lines.length; i++) {
      if (maxY < lines[i].value1) {
        maxY = lines[i].value1;
      }
      if (maxY < lines[i].value2) {
        maxY = lines[i].value2;
      }
      if (maxY < lines[i].value3) {
        maxY = lines[i].value3;
      }
      if (maxY < lines[i].value4) {
        maxY = lines[i].value4;
      }
      if (maxY < lines[i].value5) {
        maxY = lines[i].value5;
      }
      if (maxY < lines[i].value6) {
        maxY = lines[i].value6;
      }
      if (maxY < lines[i].value7) {
        maxY = lines[i].value7;
      }
      if (maxY < lines[i].value8) {
        maxY = lines[i].value8;
      }
      if (maxY < lines[i].value9) {
        maxY = lines[i].value9;
      }
      if (maxY < lines[i].value10) {
        maxY = lines[i].value10;
      }
      if (maxY < lines[i].value11) {
        maxY = lines[i].value11;
      }
      if (maxY < lines[i].value12) {
        maxY = lines[i].value12;
      }
    }
    num temp = maxY;
    int zeros = 1;
    while (temp > 1) {
      zeros = zeros * 10;
      temp = temp / 10;
    }
    num y1 = 0;
    num y2 = 0;
    num y3 = 0;
    num y4 = 0;
    num y5 = 0;
    if (maxY < zeros / 2) {
      y5 = zeros / 2;
    } else {
      y5 = zeros;
    }
    y1 = y5 / 5;
    y2 = 2 * y5 / 5;
    y3 = 3 * y5 / 5;
    y4 = 4 * y5 / 5;
    final monthNow = Moment.now().month;
    LineModel lineModel1 = LineModel(
      title: 'Thống kê tài khoản được tạo trong 12 tháng',
      x1: _monthIntToString(monthNow - 11),
      x2: _monthIntToString(monthNow - 10),
      x3: _monthIntToString(monthNow - 9),
      x4: _monthIntToString(monthNow - 8),
      x5: _monthIntToString(monthNow - 7),
      x6: _monthIntToString(monthNow - 6),
      x7: _monthIntToString(monthNow - 5),
      x8: _monthIntToString(monthNow - 4),
      x9: _monthIntToString(monthNow - 3),
      x10: _monthIntToString(monthNow - 2),
      x11: _monthIntToString(monthNow - 1),
      x12: _monthIntToString(monthNow),
      y1: y1.toString(),
      y2: y2.toString(),
      y3: y3.toString(),
      y4: y4.toString(),
      y5: y5.toString(),
      lines: lines,
    );
    int value1 = 0;
    int value2 = 0;
    int value3 = 0;
    int value4 = 0;
    int value5 = 0;
    int value6 = 0;
    int value7 = 0;
    int value8 = 0;
    int value9 = 0;
    int value10 = 0;
    int value11 = 0;
    int value12 = 0;
    for (int i = 0; i < lines.length; i++) {
      value1 += lines[i].value1;
      value2 += lines[i].value2;
      value3 += lines[i].value3;
      value4 += lines[i].value4;
      value5 += lines[i].value5;
      value6 += lines[i].value6;
      value7 += lines[i].value7;
      value8 += lines[i].value8;
      value9 += lines[i].value9;
      value10 += lines[i].value10;
      value11 += lines[i].value11;
      value12 += lines[i].value12;
    }
    num lineModel2y1 = 0;
    num lineModel2y2 = 0;
    num lineModel2y3 = 0;
    num lineModel2y4 = 0;
    num lineModel2y5 = 0;
    num temp2 = maxY;
    int zeros2 = 1;
    while (temp2 > 1) {
      zeros2 = zeros2 * 10;
      temp2 = temp2 / 10;
    }
    if (maxY < zeros2 / 2) {
      lineModel2y5 = zeros2 / 2;
    } else {
      lineModel2y5 = zeros2;
    }
    lineModel2y1 = lineModel2y5 / 5;
    lineModel2y2 = 2 * lineModel2y5 / 5;
    lineModel2y3 = 3 * lineModel2y5 / 5;
    lineModel2y4 = 4 * lineModel2y5 / 5;
    Line lineSum = Line(
      title: 'sum line',
      value1: value1,
      value2: value2,
      value3: value3,
      value4: value4,
      value5: value5,
      value6: value6,
      value7: value7,
      value8: value8,
      value9: value9,
      value10: value10,
      value11: value11,
      value12: value12,
    );

    LineModel lineModel2 = LineModel(
      title: 'sum',
      x1: lineModel1.x1,
      x2: lineModel1.x2,
      x3: lineModel1.x3,
      x4: lineModel1.x4,
      x5: lineModel1.x5,
      x6: lineModel1.x6,
      x7: lineModel1.x7,
      x8: lineModel1.x8,
      x9: lineModel1.x9,
      x10: lineModel1.x10,
      x11: lineModel1.x11,
      x12: lineModel1.x12,
      y1: lineModel2y1.toString(),
      y2: lineModel2y2.toString(),
      y3: lineModel2y3.toString(),
      y4: lineModel2y4.toString(),
      y5: lineModel2y5.toString(),
      lines: [lineSum],
    );

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 28,
          right: 28,
        ),
        child: LineChartSample1(lineModel: lineModel1),
      ),
      const SizedBox(
        height: 22,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28),
        child: LineChartSample2(lineModel: lineModel2),
      ),
      const SizedBox(height: 100),
    ]);
  }

  String _monthIntToString(int month) {
    while (month < 1) {
      month += 12;
    }
    while (month > 12) {
      month -= 12;
    }
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return '';
    }
  }
}
