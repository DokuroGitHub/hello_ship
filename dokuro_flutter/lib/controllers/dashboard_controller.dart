import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'auth_controller.dart';

// hide nav bar
class ScrollListener extends ChangeNotifier {
  double bottom = 0;
  double _last = 0;

  ScrollListener.initialise(ScrollController controller, [double height = 69]) {
    controller.addListener(() {
      final current = controller.offset;
      bottom += _last - current;
      if (bottom <= -height) bottom = -height;
      if (bottom >= 0) bottom = 0;
      _last = current;
      if (bottom <= 0 && bottom >= -height) notifyListeners();
    });
  }
}

class DashboardController extends GetxController {
  Rx<Status> status = Status.ready.obs;
  final dbService = Get.find<DbService>();
  Rxn<User> currentUser = Get.find<AuthController>().authedUser;
  RxInt selectedIndex = 0.obs;
  final ScrollController controller = ScrollController();
  final double bottomNavBarHeight = 63;
  late final ScrollListener model;

  // update last online every 30s
  runOnlineMutation() {
    Future.doWhile(
      () async {
        debugPrint(
            'Dashboard, runOnlineMutation ${DateTime.now().toUtc().toIso8601String()}');
        await dbService.updateUserByIdLastSeen(currentUser.value!.id);
        await Future.delayed(const Duration(seconds: 30));
        return true;
      },
    );
  }

  void initPlz() {
    debugPrint('$runtimeType initPlz');
    runOnlineMutation();
    model = ScrollListener.initialise(controller, bottomNavBarHeight);
  }

  void disposePlz() {
    debugPrint('$runtimeType disposePlz');
    selectedIndex.value = 0;
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
