import 'package:get/get.dart';
import 'package:flutter_graphql/services/get_storage/get_storage_service.dart';

class SampleController extends GetxController {
  late RxBool isCompleted;

  Future<void> onGetStarted() async {
    isCompleted.value = true;
  }

  @override
  void onInit() {
    isCompleted = getStorageService.getIsWelcomeCompleted().obs;
    ever(isCompleted, (_) {
      getStorageService.setIsWelcomeCompleted(isCompleted.value);
    });

    super.onInit();
  }
}
