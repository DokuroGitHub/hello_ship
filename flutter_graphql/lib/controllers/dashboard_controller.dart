// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/controllers/auth_controller.dart';
import 'package:flutter_graphql/services/auth_service.dart';
import 'package:flutter_graphql/services/get_storage/get_storage_service.dart';

import '../models/user.dart';
import 'auth_controller.dart';

//TODO: hide nav bar
class ScrollListener extends ChangeNotifier {
  double bottom = 0;
  double _last = 0;

  ScrollListener.initialise(ScrollController controller, [double height = 56]) {
    controller.addListener(() {
      final current = controller.offset;
      bottom += _last - current;
      if (bottom <= -height) bottom = -height;
      if (bottom >= 0) bottom = 0;
      _last = current;
      if (bottom <= 0 && bottom >= -height) notifyListeners();
    });
  }
}

enum UserRole { roleAdmin, roleShipper, roleUser, anonymous }

class DashboardController extends GetxController {
  Rxn<UserRole?> userRole = Rxn<UserRole?>();

  RxInt selectedIndex = 0.obs;
  late final ScrollListener model;
  late final ScrollController controller;
  final double bottomNavBarHeight = 60;

  Future<void> onGetStarted() async {}

  @override
  void onInit() {
    controller = ScrollController();
    model = ScrollListener.initialise(controller, bottomNavBarHeight);
    final authController = Get.find<AuthController>();
    if (authController.authedUser.value?.role == 'role_admin') {
      userRole.value = UserRole.roleAdmin;
    } else if (authController.authedUser.value?.role == 'role_shipper') {
      userRole.value = UserRole.roleShipper;
    } else if (authController.authedUser.value?.role == 'role_user') {
      userRole.value = UserRole.roleUser;
    }
    super.onInit();
  }
}
