import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/controllers/welcome/welcome_controller.dart';
import 'package:flutter_graphql/screens/welcome/welcome_screen.dart';

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
