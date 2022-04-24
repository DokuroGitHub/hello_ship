import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import 'dashboard_screen_for_user.dart';

class DashboardSplash extends StatelessWidget {
  const DashboardSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardController());

    return Obx(() {
      if (dashboardController.userRole.value == UserRole.roleAdmin) {
        debugPrint('DashboardSplash, role_admin');
        return Container();
      } else if (dashboardController.userRole.value == UserRole.roleShipper) {
        debugPrint('DashboardSplash, role_shipper');
        return Container();
      } else if (dashboardController.userRole.value == UserRole.roleUser) {
        debugPrint('DashboardSplash, role_user');
        return const DashboardScreenForUser();
      } else {
        debugPrint('DashboardSplash, role null');
        return Container();
      }
    });
  }
}
