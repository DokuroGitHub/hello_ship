import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/screens/sign_in/email_password_sign_in_screen.dart';
import '../welcome/welcome_controller.dart';

class SignInController extends GetxController {
  late RxBool isLoading;
  dynamic error;

  Future<void> onGetStarted() async {
    isLoading.value = true;
  }

  Future<void> showWelcomeScreenNextTime() async {
    final welcomeController = Get.find<WelcomeController>();
    welcomeController.onReGetStart();
  }

  Future<void> _signIn(Function() signInMethod) async {
    try {
      isLoading.value = true;
      await signInMethod();
      error = null;
    } catch (e) {
      error = e;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAnonymously() async {
    debugPrint('signInAnonymously');
    //await _signIn(AuthService().signInAnonymously);
  }

  Future<void> signInWithGoogle() async {
    debugPrint('signInWithGoogle');
    //await _signIn(AuthService().signInWithGoogle);
  }

  Future<void> showEmailPasswordSignInScreen() async {
    debugPrint('showEmailPasswordSignInScreen');
    Get.to(()=>const EmailPasswordSignInScreen());
  }

  @override
  void onInit() {
    isLoading = false.obs;

    super.onInit();
  }
}
