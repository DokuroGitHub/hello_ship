import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_moment/simple_moment.dart';

class ChartsController {
  final dbService = Get.find<DbService>();
  final scrollController = Get.find<DashboardController>().controller;
  final User currentUser = Get.find<AuthController>().authedUser.value!;
  final _duration = const Duration(milliseconds: 300);
  final _curve = Curves.easeInOutCubic;
  final pageController = PageController(initialPage: 0);
  RxInt currentPage = 0.obs;

  // users
  RxInt countAdmins = 0.obs;
  RxInt countShippers = 0.obs;
  RxInt countUsers = 0.obs;

  RxInt monthFrom0To1Admin = 0.obs;
  RxInt monthFrom1To2Admin = 0.obs;
  RxInt monthFrom2To3Admin = 0.obs;
  RxInt monthFrom3To4Admin = 0.obs;
  RxInt monthFrom4To5Admin = 0.obs;
  RxInt monthFrom5To6Admin = 0.obs;
  RxInt monthFrom6To7Admin = 0.obs;
  RxInt monthFrom7To8Admin = 0.obs;
  RxInt monthFrom8To9Admin = 0.obs;
  RxInt monthFrom9To10Admin = 0.obs;
  RxInt monthFrom10To11Admin = 0.obs;
  RxInt monthFrom11To12Admin = 0.obs;
  RxInt monthFrom0To1Shipper = 0.obs;
  RxInt monthFrom1To2Shipper = 0.obs;
  RxInt monthFrom2To3Shipper = 0.obs;
  RxInt monthFrom3To4Shipper = 0.obs;
  RxInt monthFrom4To5Shipper = 0.obs;
  RxInt monthFrom5To6Shipper = 0.obs;
  RxInt monthFrom6To7Shipper = 0.obs;
  RxInt monthFrom7To8Shipper = 0.obs;
  RxInt monthFrom8To9Shipper = 0.obs;
  RxInt monthFrom9To10Shipper = 0.obs;
  RxInt monthFrom10To11Shipper = 0.obs;
  RxInt monthFrom11To12Shipper = 0.obs;
  RxInt monthFrom0To1User = 0.obs;
  RxInt monthFrom1To2User = 0.obs;
  RxInt monthFrom2To3User = 0.obs;
  RxInt monthFrom3To4User = 0.obs;
  RxInt monthFrom4To5User = 0.obs;
  RxInt monthFrom5To6User = 0.obs;
  RxInt monthFrom6To7User = 0.obs;
  RxInt monthFrom7To8User = 0.obs;
  RxInt monthFrom8To9User = 0.obs;
  RxInt monthFrom9To10User = 0.obs;
  RxInt monthFrom10To11User = 0.obs;
  RxInt monthFrom11To12User = 0.obs;

  void initPlz() {
    fetchUserRoles();
    fetchUsersByCreatedAtTimeFromTimeToRole();
  }

  void onNextPageTap() {
    pageController.nextPage(duration: _duration, curve: _curve);
  }

  void onPreviousPageTap() {
    pageController.previousPage(duration: _duration, curve: _curve);
  }

  Future<void> fetchUserRoles() async {
    try {
      var result = await dbService.fetchUserRoles();
      countAdmins.value = result?['count_admins']?['totalCount'] ?? 0;
      countShippers.value = result?['count_shippers']?['totalCount'] ?? 0;
      countUsers.value = result?['count_users']?['totalCount'] ?? 0;
    } catch (e) {
      debugPrint('e: $e');
    }
    return;
  }

  Future<void> fetchUsersByCreatedAtTimeFromTimeToRole() async {
    try {
      final now = Moment.now();
      var result = await dbService.fetchUsersByCreatedAtTimeFromTimeToRole(
        time0: now.date,
        time1: DateTime(now.year, now.month),
        time2: DateTime(
            now.subtract(months: 1).year, now.subtract(months: 1).month),
        time3: DateTime(
            now.subtract(months: 2).year, now.subtract(months: 2).month),
        time4: DateTime(
            now.subtract(months: 3).year, now.subtract(months: 3).month),
        time5: DateTime(
            now.subtract(months: 4).year, now.subtract(months: 4).month),
        time6: DateTime(
            now.subtract(months: 5).year, now.subtract(months: 5).month),
        time7: DateTime(
            now.subtract(months: 6).year, now.subtract(months: 6).month),
        time8: DateTime(
            now.subtract(months: 7).year, now.subtract(months: 7).month),
        time9: DateTime(
            now.subtract(months: 8).year, now.subtract(months: 8).month),
        time10: DateTime(
            now.subtract(months: 9).year, now.subtract(months: 9).month),
        time11: DateTime(
            now.subtract(months: 10).year, now.subtract(months: 10).month),
        time12: DateTime(
            now.subtract(months: 11).year, now.subtract(months: 11).month),
      );

      // admin
      monthFrom0To1Admin.value =
          result?['monthFrom0To1Admin']?['totalCount'] ?? 0;
      monthFrom1To2Admin.value =
          result?['monthFrom1To2Admin']?['totalCount'] ?? 0;
      monthFrom2To3Admin.value =
          result?['monthFrom2To3Admin']?['totalCount'] ?? 0;
      monthFrom3To4Admin.value =
          result?['monthFrom3To4Admin']?['totalCount'] ?? 0;
      monthFrom4To5Admin.value =
          result?['monthFrom4To5Admin']?['totalCount'] ?? 0;
      monthFrom5To6Admin.value =
          result?['monthFrom5To6Admin']?['totalCount'] ?? 0;
      monthFrom6To7Admin.value =
          result?['monthFrom6To7Admin']?['totalCount'] ?? 0;
      monthFrom7To8Admin.value =
          result?['monthFrom7To8Admin']?['totalCount'] ?? 0;
      monthFrom8To9Admin.value =
          result?['monthFrom8To9Admin']?['totalCount'] ?? 0;
      monthFrom9To10Admin.value =
          result?['monthFrom9To10Admin']?['totalCount'] ?? 0;
      monthFrom10To11Admin.value =
          result?['monthFrom10To11Admin']?['totalCount'] ?? 0;
      monthFrom11To12Admin.value =
          result?['monthFrom11To12Admin']?['totalCount'] ?? 0;
      // shipper
      monthFrom0To1Shipper.value =
          result?['monthFrom0To1Shipper']?['totalCount'] ?? 0;
      monthFrom1To2Shipper.value =
          result?['monthFrom1To2Shipper']?['totalCount'] ?? 0;
      monthFrom2To3Shipper.value =
          result?['monthFrom2To3Shipper']?['totalCount'] ?? 0;
      monthFrom3To4Shipper.value =
          result?['monthFrom3To4Shipper']?['totalCount'] ?? 0;
      monthFrom4To5Shipper.value =
          result?['monthFrom4To5Shipper']?['totalCount'] ?? 0;
      monthFrom5To6Shipper.value =
          result?['monthFrom5To6Shipper']?['totalCount'] ?? 0;
      monthFrom6To7Shipper.value =
          result?['monthFrom6To7Shipper']?['totalCount'] ?? 0;
      monthFrom7To8Shipper.value =
          result?['monthFrom7To8Shipper']?['totalCount'] ?? 0;
      monthFrom8To9Shipper.value =
          result?['monthFrom8To9Shipper']?['totalCount'] ?? 0;
      monthFrom9To10Shipper.value =
          result?['monthFrom9To10Shipper']?['totalCount'] ?? 0;
      monthFrom10To11Shipper.value =
          result?['monthFrom10To11Shipper']?['totalCount'] ?? 0;
      monthFrom11To12Shipper.value =
          result?['monthFrom11To12Shipper']?['totalCount'] ?? 0;
      //user
      monthFrom0To1User.value =
          result?['monthFrom0To1User']?['totalCount'] ?? 0;
      monthFrom1To2User.value =
          result?['monthFrom1To2User']?['totalCount'] ?? 0;
      monthFrom2To3User.value =
          result?['monthFrom2To3User']?['totalCount'] ?? 0;
      monthFrom3To4User.value =
          result?['monthFrom3To4User']?['totalCount'] ?? 0;
      monthFrom4To5User.value =
          result?['monthFrom4To5User']?['totalCount'] ?? 0;
      monthFrom5To6User.value =
          result?['monthFrom5To6User']?['totalCount'] ?? 0;
      monthFrom6To7User.value =
          result?['monthFrom6To7User']?['totalCount'] ?? 0;
      monthFrom7To8User.value =
          result?['monthFrom7To8User']?['totalCount'] ?? 0;
      monthFrom8To9User.value =
          result?['monthFrom8To9User']?['totalCount'] ?? 0;
      monthFrom9To10User.value =
          result?['monthFrom9To10User']?['totalCount'] ?? 0;
      monthFrom10To11User.value =
          result?['monthFrom10To11User']?['totalCount'] ?? 0;
      monthFrom11To12User.value =
          result?['monthFrom11To12User']?['totalCount'] ?? 0;
    } catch (e) {
      debugPrint('e: $e');
    }
    return;
  }
}
