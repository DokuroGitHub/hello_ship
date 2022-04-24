import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_graphql/services/get_storage/get_storage_service.dart';

class WelcomeController extends GetxController {
  late RxBool isCompleted;

  Future<void> onGetStarted() async {
    isCompleted.value = true;
  }

  Future<void> onReGetStart() async {
    isCompleted.value = false;
  }

  @override
  void onInit() {
    isCompleted = getStorageService.getIsWelcomeCompleted().obs;
    ever(isCompleted, (_) {
      debugPrint('isCompleted, $isCompleted');
      getStorageService.setIsWelcomeCompleted(isCompleted.value);
    });

    super.onInit();
  }
}
