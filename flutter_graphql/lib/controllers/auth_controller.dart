import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/services/auth_service.dart';
import 'package:flutter_graphql/services/get_storage/get_storage_service.dart';

import '../models/user.dart';
import '../screens/dashboard_splash.dart';
import '../screens/welcome/welcome_splash.dart';

class AuthController extends GetxController {
  late Rxn<User?> authedUser;

  check() async {
    final String? token = getStorageService.token;
    if (token != null) {
      final User? user = authService.signInWithToken(token: token);
      if (user != null) {
        authedUser.value = user;
      }
    }
    await Future.delayed(const Duration(seconds: 5));
    if (authedUser.value != null) {
      Get.to(() => const DashboardSplash());
    } else {
      Get.to(() => const WelcomeSplash());
    }
  }

  @override
  void onInit() {
    debugPrint('AuthController');
    authedUser = Rxn<User?>();

    super.onInit();
  }
}
