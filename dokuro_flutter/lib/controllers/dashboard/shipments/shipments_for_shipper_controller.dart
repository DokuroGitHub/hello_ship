import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/constants/shipment_service.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:dokuro_flutter/models/constants/shipment_type.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/screens/dashboard/shipments/shipment_item.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ShipmentsForShipperController {
  Rx<Status> status = Status.loading.obs;
  final dbService = Get.find<DbService>();
  final scrollController = Get.find<DashboardController>().controller;
  final currentUser = Get.find<AuthController>().authedUser.value!;
  final int _limit = 2;
  final shipmentTypes = [ShipmentType.transport, ShipmentType.delivery];
  final shipmentServices = [ShipmentService.fast, ShipmentService.saving];

  RxString type = ShipmentType.transport.obs;
  RxString service = ShipmentService.fast.obs;
  Rx<TextEditingController> codTEC = TextEditingController().obs;
  Rx<TextEditingController> notesTEC = TextEditingController().obs;
  Rx<TextEditingController> phoneTEC = TextEditingController().obs;
  Rx<TextEditingController> addressFromDetailsTEC = TextEditingController().obs;
  Rx<TextEditingController> addressFromStreetTEC = TextEditingController().obs;
  Rx<TextEditingController> addressFromDistrictTEC =
      TextEditingController().obs;
  Rx<TextEditingController> addressFromCityTEC = TextEditingController().obs;
  Rx<TextEditingController> addressToDetailsTEC = TextEditingController().obs;
  Rx<TextEditingController> addressToStreetTEC = TextEditingController().obs;
  Rx<TextEditingController> addressToDistrictTEC = TextEditingController().obs;
  Rx<TextEditingController> addressToCityTEC = TextEditingController().obs;

  bool _loadingMore = false;

  // shipments
  RxList<ShipmentItem> shipmentItems = RxList();
  Rx<PageInfo> shipmentsPageInfo = PageInfo().obs;
  RxInt shipmentsTotalCount = 0.obs;

  // chips
  RxString chipStatus = ShipmentStatus.undefined.obs;

  void _scrollListener() {
    if (scrollController.position.maxScrollExtent <= 0) {
      debugPrint(scrollController.position.extentBefore.toString());
    }

    if (scrollController.position.extentAfter < 100) {
      if (!_loadingMore) {
        _loadingMore = true;
        debugPrint('shipmentsPageInfo: $shipmentsPageInfo}');
        if (shipmentsPageInfo.value.hasNextPage == true) {
          fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter();
        }
      }
    } else {
      _loadingMore = false;
    }
  }

  void resetShipments() {
    shipmentItems.value = [];
    shipmentsPageInfo.value = PageInfo();
    shipmentsTotalCount.value = 0;
  }

  void initPlz() {
    scrollController.addListener(_scrollListener);
    fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  Future<void>
      fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter() async {
    try {
      Map<String, dynamic> condition = {};
      if (chipStatus.value != ShipmentStatus.undefined) {
        condition = {
          'status': chipStatus.value,
        };
      }
      var moreItems = await dbService
          .shipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter(
        currentUser.id,
        condition,
        _limit,
        shipmentsPageInfo.value.endCursor,
      );
      if (moreItems != null) {
        shipmentsTotalCount.value = moreItems.totalCount;
        shipmentsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        shipmentItems.addAll(moreItems.nodes.map((e) {
          return ShipmentItem(
            e,
            initialKey: Key(e.id.toString()),
            onDeleteCallBack: () {
              shipmentItems.removeWhere(
                  (element) => element.key == Key(e.id.toString()));
            },
          );
        }));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }
}
