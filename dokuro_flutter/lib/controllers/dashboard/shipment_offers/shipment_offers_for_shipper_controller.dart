import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/shipment/shipment_offer_item.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ShipmentOffersForShipperController {
  Rx<Status> status = Status.loading.obs;
  final scrollController = Get.find<DashboardController>().controller;
  final currentUser = Get.find<AuthController>().authedUser.value!;
  final dbService = Get.find<DbService>();
  final int _limit = 2;

  bool _loadingMore = false;

  // shipmentOffers
  RxList<ShipmentOfferItem> offerItems = RxList();
  Rx<PageInfo> offersPageInfo = PageInfo().obs;
  RxInt offersTotalCount = 0.obs;

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('offersPageInfo: $offersPageInfo}');
        if (offersPageInfo.value.hasNextPage == true) {
          fetchShipmentsByShipmentOffersByCurrentUserIdFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void initPlz() {
    scrollController.addListener(_scrollListener);
    fetchShipmentsByShipmentOffersByCurrentUserIdFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  Future<void> fetchShipmentsByShipmentOffersByCurrentUserIdFirstAfter() async {
    try {
      var moreItems = await dbService.shipmentOffersByCreatedByFirstAfter(
        currentUser.id,
        _limit,
        offersPageInfo.value.endCursor,
      );
      if (moreItems != null) {
        offersTotalCount.value = moreItems.totalCount;
        offersPageInfo.value = moreItems.pageInfo ?? PageInfo();
        offerItems.addAll(moreItems.nodes.map((e) => ShipmentOfferItem(
              e,
              initialKey: Key(e.id.toString()),
              onDeleteCallBack: () {
                offerItems.removeWhere(
                    (element) => element.key == Key(e.id.toString()));
              },
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }
}
