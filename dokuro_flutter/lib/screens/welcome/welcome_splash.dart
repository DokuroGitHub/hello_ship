import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/controllers/welcome_controller.dart';
import 'package:dokuro_flutter/screens/welcome/welcome_screen.dart';

import '../sign_in/sign_in_screen.dart';

class WelcomeSplash extends StatelessWidget {
  const WelcomeSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('WelcomeSplash');
    final welcomeController = Get.put(WelcomeController());

    return Obx(
      () => welcomeController.isCompleted.isTrue
          ? const SignInScreen()
          : const WelcomeScreen(),
    );
  }
}
