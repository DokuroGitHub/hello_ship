import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/post_reports/post_report_item.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class PostReportsController {
  final dbService = Get.find<DbService>();
  final int _limit = 2;
  final scrollController = Get.find<DashboardController>().controller;
  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;
  bool _loadingMore = false;

  // userReports
  RxList<PostReportItem> reportItems = RxList();
  Rx<PageInfo> reportsPageInfo = PageInfo().obs;
  RxInt reportsTotalCount = 0.obs;

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('reportsPageInfo: $reportsPageInfo}');
        if (reportsPageInfo.value.hasNextPage == true) {
          fetchReportedUsersByConditionFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void resetReports() {
    reportItems.clear();
    reportsPageInfo.value = PageInfo();
    reportsTotalCount.value = 0;
  }

  void initPlz() {
    scrollController.addListener(_scrollListener);
    fetchReportedUsersByConditionFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  Future<void> fetchReportedUsersByConditionFirstAfter() async {
    try {
      Map<String, dynamic> condition = {};
      var moreItems = await dbService.reportedUsersByConditionFirstAfter(
        condition,
        _limit,
        reportsPageInfo.value.endCursor,
      );
      if (moreItems != null) {
        reportsTotalCount.value = moreItems.totalCount;
        reportsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        reportItems.addAll(moreItems.nodes.map((e) => PostReportItem(
              e,
              initialKey: Key(e.id.toString()),
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }
}
