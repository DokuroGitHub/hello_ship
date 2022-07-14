import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/unblock_request.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/unblock_requests/unblock_request_item.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:dokuro_flutter/data/user_query.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class UnblockRequestsController {
  final _client = Get.find<DbService>().client!;
  final int _limit = 2;
  final scrollController = Get.find<DashboardController>().controller;
  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;
  bool _loadingMore = false;

  // unblockRequests
  RxList<UnblockRequestItem> requestItems = RxList();
  Rx<PageInfo> requestsPageInfo = PageInfo().obs;
  RxInt requestsTotalCount = 0.obs;

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('requestsPageInfo: $requestsPageInfo}');
        if (requestsPageInfo.value.hasNextPage == true) {
          fetchUnblockRequestsByConditionFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void resetRequests() {
    requestItems.clear();
    requestsPageInfo.value = PageInfo();
    requestsTotalCount.value = 0;
  }

  void initPlz() {
    scrollController.addListener(_scrollListener);
    fetchUnblockRequestsByConditionFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  Future<void> fetchUnblockRequestsByConditionFirstAfter() async {
    try {
      var moreItems = await _unblockRequestsByConditionFirstAfter();
      if (moreItems != null) {
        requestsTotalCount.value = moreItems.totalCount;
        requestsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        requestItems.addAll(moreItems.nodes.map((e) => UnblockRequestItem(
              e,
              initialKey: Key(e.id.toString()),
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<UnblockRequests?> _unblockRequestsByConditionFirstAfter() async {
    try {
      var condition = {};
      var result = await _client.query(
        QueryOptions(
          document: gql(UserQuery.unblockRequestsByConditionFirstAfter),
          variables: {
            'condition': condition,
            'first': _limit,
            'after': requestsPageInfo.value.endCursor,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );
      if (result.hasException) {
        debugPrint(
            '_unblockRequestsByConditionFirstAfter: ${result.exception.toString()}');
        return null;
      }
      final map = result.data?['unblockRequests'];
      debugPrint('_unblockRequestsByConditionFirstAfter, map, $map');
      return convertMapToUnblockRequests(map);
    } catch (e) {
      debugPrint('e: $e');
    }
    return null;
  }
}
