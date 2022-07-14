import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/screens/dashboard_splash.dart';
import 'package:dokuro_flutter/screens/welcome/welcome_splash.dart';

import '../constants/status.dart';
import '../controllers/auth_controller.dart';

class AuthSplash extends StatelessWidget {
  const AuthSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('AuthSplash');
    final authController = Get.put(AuthController());

    return Obx(() {
      if (authController.status.value == Status.ready) {
        return authController.authedUser.value != null
            ? const DashboardSplash()
            : const WelcomeSplash();
      }
      if (authController.status.value == Status.failure) {
        return const WelcomeSplash();
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
