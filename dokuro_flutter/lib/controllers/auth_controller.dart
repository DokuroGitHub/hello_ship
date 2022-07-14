import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rx<Status> status = Status.ready.obs;
  final authService = Get.find<AuthService>();
  Rxn<User> authedUser = Rxn();

  void initPlz() {
    debugPrint('$runtimeType initPlz');
    authedUser = authService.currentUser;
  }

  void disposePlz() {
    debugPrint('$runtimeType disposePlz');
    authedUser.value = null;
  }

  @override
  void onInit() {
    initPlz();
    super.onInit();
  }

  @override
  void dispose() {
    disposePlz();
    super.dispose();
  }
}
