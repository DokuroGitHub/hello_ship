import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/screens/dashboard/account/account_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/charts/charts_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/post_reports/post_reports_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/posts/posts_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/unblock_requests/unblock_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class DashboardScreenForAdmin extends StatelessWidget {
  const DashboardScreenForAdmin({Key? key}) : super(key: key);

  final List<Widget> widgetOptions = const [
    // page 0
    PostsScreen(),
    // page 1
    ChartsScreen(),
    // page 2
    PostReportsScreen(),
    // page 3
    UnblockRequestsScreen(),
    // page 4
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('DashboardScreenForUser');
    final dashboardController = Get.find<DashboardController>();

    return Scaffold(
      body: AnimatedBuilder(
        animation: dashboardController.model,
        builder: (context, child) {
          return Obx(() => Stack(
                children: [
                  // content
                  widgetOptions[dashboardController.selectedIndex.value],
                  // _bottomNavBar
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: dashboardController.model.bottom,
                    child: _bottomNavBar(dashboardController),
                  ),
                ],
              ));
        },
      ),
    );
  }

  Widget _bottomNavBar(DashboardController dashboardController) {
    return SizedBox(
      height: dashboardController.bottomNavBarHeight,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.post_add),
              tooltip: 'Posts here',
              label: AppLocalizations.of(Get.context!).posts,
              backgroundColor: Colors.green),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            tooltip: 'Post reports here',
            label: 'Charts',
            backgroundColor: Colors.blue,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.report),
            tooltip: 'Post reports here',
            label: 'Reports',
            backgroundColor: Colors.blue,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            tooltip: 'Unblock requests here',
            label: 'Requests',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            tooltip: 'Profile here',
            label: AppLocalizations.of(Get.context!).account,
            backgroundColor: Colors.blue,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: dashboardController.selectedIndex.value,
        selectedItemColor: Colors.black,
        //backgroundColor: Colors.blue,
        iconSize: 30,
        onTap: (index) {
          dashboardController.selectedIndex.value = index;
        },
        elevation: 5,
      ),
    );
  }
}
