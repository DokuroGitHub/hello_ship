import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/constants/account_role.dart';
import 'package:dokuro_flutter/screens/dashboard/blocked_screen.dart';
import 'package:dokuro_flutter/screens/dashboard/dashboard_screen_for_admin.dart';
import 'package:dokuro_flutter/screens/dashboard/dashboard_screen_for_shipper.dart';
import 'package:dokuro_flutter/screens/dashboard/dashboard_screen_for_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardSplash extends StatelessWidget {
  const DashboardSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardController());
    final currentUser = dashboardController.currentUser.value;
    if (currentUser == null) {
      return const SizedBox();
    }
    if (currentUser.blockedUntil != null &&
        currentUser.blockedUntil!.compareTo(DateTime.now()) > 0) {
      return const BlockedScreen();
    }
    if (currentUser.role == AccountRole.roleAdmin) {
      debugPrint('DashboardSplash, role_admin');
      return const DashboardScreenForAdmin();
    } else if (currentUser.role == AccountRole.roleShipper) {
      debugPrint('DashboardSplash, role_shipper');
      return const DashboardScreenForShipper();
    } else if (currentUser.role == AccountRole.roleUser) {
      debugPrint('DashboardSplash, role_user');
      return const DashboardScreenForUser();
    } else {
      debugPrint('DashboardSplash, role null');
      return const SizedBox();
    }
  }
}
