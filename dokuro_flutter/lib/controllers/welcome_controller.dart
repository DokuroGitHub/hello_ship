import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/services/get_storage/get_storage_service.dart';

import '../constants/status.dart';

class WelcomeController extends GetxController {
  Rx<Status> status = Status.loading.obs;
  late RxBool isCompleted;

  void onGetStarted() {
    isCompleted.value = true;
  }

  void onReGetStart() {
    isCompleted.value = false;
  }

  @override
  void onInit() {
    debugPrint('WelcomeController');
    ever(status, (_) {
      debugPrint('status: $status');
    });
    isCompleted = getStorageService.getIsWelcomeCompleted().obs;
    ever(isCompleted, (_) {
      debugPrint('isCompleted, ${isCompleted.value}');
      getStorageService.setIsWelcomeCompleted(isCompleted.value);
    });

    super.onInit();
    status.value = Status.ready;
  }
}
