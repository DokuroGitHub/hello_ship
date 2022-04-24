import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/screens/dashboard_splash.dart';
import 'package:flutter_graphql/screens/welcome/welcome_splash.dart';

import '../controllers/auth_controller.dart';

class AuthSplash extends StatelessWidget {
  const AuthSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('AuthSplash');
    final authController = Get.put(AuthController());

    return Obx(
      () => authController.authedUser.value != null
          ? const DashboardSplash()
          : const WelcomeSplash(),
    );
  }
}
