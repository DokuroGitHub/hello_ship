import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/welcome_controller.dart';
import 'package:dokuro_flutter/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/screens/sign_in/email_password_sign_in_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInController extends GetxController {
  Rx<Status> status = Status.loading.obs;
  dynamic error;
  final authService = Get.find<AuthService>();

  Future<void> showWelcomeScreenNextTime() async {
    final welcomeController = Get.find<WelcomeController>();
    welcomeController.onReGetStart();
  }

  Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> signIn(Function() signInMethod) async {
    try {
      status.value = Status.loading;
      await signInMethod();
      error = null;
    } catch (e) {
      error = e;
      rethrow;
    } finally {
      status.value = Status.ready;
    }
  }

  Future<void> signInWithAuth0() async {
    await authService.signInWithAuth0();
  }

  Future<void> showEmailPasswordSignInScreen() async {
    Get.to(() => const EmailPasswordSignInScreen());
  }

  @override
  void onInit() {
    debugPrint('$runtimeType, onInit');
    status.value = Status.ready;
    ever(status, (_) {
      debugPrint('status: $status');
    });

    super.onInit();
    status.value = Status.ready;
  }
}
