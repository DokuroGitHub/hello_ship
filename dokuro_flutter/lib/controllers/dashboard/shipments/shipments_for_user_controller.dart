import 'dart:async';

import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard_controller.dart';
import 'package:dokuro_flutter/models/constants/shipment_service.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:dokuro_flutter/models/constants/shipment_type.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/shipment_address_from.dart';
import 'package:dokuro_flutter/models/shipment_address_to.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/screens/dashboard/shipments/shipment_item.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShipmentsForUserController {
  Rx<Status> status = Status.loading.obs;
  final dbService = Get.find<DbService>();
  final scrollController = Get.find<DashboardController>().controller;
  final currentUser = Get.find<AuthController>().authedUser.value!;
  final int _limit = 2;
  final shipmentTypes = [ShipmentType.transport, ShipmentType.delivery];
  final shipmentServices = [ShipmentService.fast, ShipmentService.saving];

  //Rx<Shipments> shipments = Shipments().obs;
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
          fetchShipmentsByConditionByFirstAfter();
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
    fetchShipmentsByConditionByFirstAfter();
  }

  void disposePlz() {
    scrollController.removeListener(_scrollListener);
  }

  void onShipmentCreateTap() {
    codTEC.value.text = '';
    notesTEC.value.text = '';
    phoneTEC.value.text = currentUser.phone;

    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              const Text('Tạo shipment'),
              Positioned(
                right: 0,
                top: 0,
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Colors.grey.withOpacity(0.25),
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ]),
          ),
        ]),
        children: [
          const Divider(thickness: 1.0),
          // avatar + name + location
          Row(children: [
            // avatar
            SizedBox(
              width: 40,
              height: 40,
              child: UserAvatar(
                avatarUrl: currentUser.avatarUrl,
                lastSeen: currentUser.lastSeen,
              ),
            ),
            const SizedBox(width: 5),
            // name + uid
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserName(name: currentUser.name),
                  TextButton.icon(
                    onPressed: () {
                      final message = 'uid: ${currentUser.uid}';
                      Clipboard.setData(ClipboardData(text: currentUser.uid));
                      Get.showSnackbar(GetSnackBar(
                        title: 'Copied',
                        message: message,
                        duration: const Duration(seconds: 1),
                      ));
                    },
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0)),
                    ),
                    icon: const Icon(Icons.person),
                    label: Text('uid: ${currentUser.uid}'),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // type
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Icon(Icons.delivery_dining),
            Flexible(child: Text('Type: ')),
          ]),
          DropdownButtonFormField<String>(
            items: shipmentTypes.map((String category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            onChanged: (newValue) {
              if (newValue != null) {
                type.value = newValue;
              }
            },
            value: ShipmentType.transport,
          ),
          const SizedBox(height: 5),
          // service
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Icon(Icons.category),
            Flexible(child: Text('Service: ')),
          ]),
          DropdownButtonFormField<String>(
            items: shipmentServices.map((String category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            onChanged: (newValue) {
              if (newValue != null) {
                service.value = newValue;
              }
            },
            value: ShipmentService.fast,
          ),
          const SizedBox(height: 5),
          // addressFrom
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Icon(Icons.location_on),
            Flexible(child: Text('Bắt đầu')),
          ]),
          TextField(
            controller: addressFromDetailsTEC.value,
            onChanged: (val) {
              addressFromDetailsTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            onTap: () {
              Get.dialog(
                SimpleDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  contentPadding:
                      const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  title: Row(children: [
                    Expanded(
                      child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            const Text('Địa chỉ bắt đầu'),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  shape: const CircleBorder(),
                                ),
                                child: IconButton(
                                  splashRadius: 20,
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                          ]),
                    )
                  ]),
                  children: [
                    const Divider(thickness: 1.0),
                    // userAddress
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.house),
                          Flexible(
                            child: Text(
                                AppLocalizations.of(Get.context!).addressCap),
                          ),
                        ]),
                    const Text('Details: '),
                    TextField(
                      controller: addressFromDetailsTEC.value,
                      onChanged: (val) {
                        addressFromDetailsTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Địa chỉ chi tiết',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 100,
                      maxLines: 2,
                    ),
                    const Text('Street: '),
                    TextField(
                      controller: addressFromStreetTEC.value,
                      onChanged: (val) {
                        addressFromStreetTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Đường',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 10,
                      maxLines: 1,
                    ),
                    const Text('District:'),
                    TextField(
                      controller: addressFromDistrictTEC.value,
                      onChanged: (val) {
                        addressFromDistrictTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Quận',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 10,
                      maxLines: 1,
                    ),
                    const Text('City:'),
                    TextField(
                      controller: addressFromCityTEC.value,
                      onChanged: (val) {
                        addressFromCityTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Tỉnh/thành phố',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 10,
                      maxLines: 1,
                    ),

                    // done
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                          onPressed: Get.back,
                          child: Text(AppLocalizations.of(Get.context!).done),
                        ),
                      )
                    ]),
                  ],
                ),
              );
            },
            decoration: const InputDecoration(
              hintText: 'Địa chỉ bắt đầu',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 100,
            maxLines: 1,
          ),
          // addressTo
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Icon(Icons.location_on),
            Flexible(child: Text('Đến')),
          ]),
          TextField(
            controller: addressToDetailsTEC.value,
            onChanged: (val) {
              addressToDetailsTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            onTap: () {
              Get.dialog(
                SimpleDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  contentPadding:
                      const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  title: Row(children: [
                    Expanded(
                      child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            const Text('Địa chỉ đến'),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.grey.withOpacity(0.25),
                                  shape: const CircleBorder(),
                                ),
                                child: IconButton(
                                  splashRadius: 20,
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                          ]),
                    )
                  ]),
                  children: [
                    const Divider(thickness: 1.0),
                    // userAddress
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.house),
                          Flexible(
                            child: Text(
                                AppLocalizations.of(Get.context!).addressCap),
                          ),
                        ]),
                    const Text('Details: '),
                    TextField(
                      controller: addressToDetailsTEC.value,
                      onChanged: (val) {
                        addressToDetailsTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Địa chỉ chi tiết',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 100,
                      maxLines: 2,
                    ),
                    const Text('Street: '),
                    TextField(
                      controller: addressToStreetTEC.value,
                      onChanged: (val) {
                        addressToStreetTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Đường',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 10,
                      maxLines: 1,
                    ),
                    const Text('District:'),
                    TextField(
                      controller: addressToDistrictTEC.value,
                      onChanged: (val) {
                        addressToDistrictTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Quận/huyện',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 10,
                      maxLines: 1,
                    ),
                    const Text('City:'),
                    TextField(
                      controller: addressToCityTEC.value,
                      onChanged: (val) {
                        addressToCityTEC.update((val) {});
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Tỉnh/thành phố',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      maxLength: 10,
                      maxLines: 1,
                    ),

                    // done
                    Row(children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                          onPressed: Get.back,
                          child: Text(AppLocalizations.of(Get.context!).done),
                        ),
                      )
                    ]),
                  ],
                ),
              );
            },
            decoration: const InputDecoration(
              hintText: 'Địa chỉ bắt đầu',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 100,
            maxLines: 1,
          ),

          // cod
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.attach_money),
            Flexible(
              child: Obx(() =>
                  Text('Price: ${int.tryParse(codTEC.value.text) ?? 0} vnđ')),
            ),
          ]),
          TextField(
            controller: codTEC.value,
            onChanged: (val) {
              codTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Giá khởi xướng',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 18,
            maxLines: 1,
          ),
          // notes
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.edit_note),
            Flexible(
              child: Obx(() => Text('Notes: ${notesTEC.value.text}')),
            ),
          ]),
          TextField(
            controller: notesTEC.value,
            onChanged: (val) {
              notesTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Ghi chú',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 50,
            maxLines: 2,
          ),
          // phone
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.phone),
            Flexible(
              child: Obx(() => Text('Phone: ${phoneTEC.value.text}')),
            ),
          ]),
          TextField(
            controller: phoneTEC.value,
            onChanged: (val) {
              phoneTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Số điện thoại',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 15,
            maxLines: 1,
          ),

          // Đăng
          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                onPressed: _onShipmentCreateSubmitTap,
                child: const Text('Đăng'),
              ),
            )
          ]),
        ],
      ),
      //barrierDismissible: false,
    );
  }

  Future<void> _onShipmentCreateSubmitTap() async {
    //shipment
    final shipment =
        await dbService.createShipmentByCreatedByTypeServiceCodNotesPhoneStatus(
      currentUser.id,
      type.value,
      service.value,
      int.tryParse(codTEC.value.text),
      notesTEC.value.text.isNotEmpty ? notesTEC.value.text : null,
      phoneTEC.value.text.isNotEmpty ? phoneTEC.value.text : null,
      ShipmentStatus.finding,
    );
    if (shipment == null) {
      Get.snackbar(
        'Failed:',
        'Could not create shipment',
        duration: const Duration(seconds: 2),
      );
    } else {
      //addressFrom
      final addressFrom = await dbService
          .createShipmentAddressFromByShipmentIdDetailsStreetDistrictCityLocation(
              ShipmentAddressFrom(
        shipmentId: shipment.id,
        details: addressFromDetailsTEC.value.text,
        street: addressFromStreetTEC.value.text,
        district: addressFromDistrictTEC.value.text,
        city: addressFromCityTEC.value.text,
        location: null,
      ));
      //addressTo
      final addressTo = await dbService
          .createShipmentAddressToByShipmentIdDetailsStreetDistrictCityLocation(
              ShipmentAddressTo(
        shipmentId: shipment.id,
        details: addressToDetailsTEC.value.text,
        street: addressToStreetTEC.value.text,
        district: addressToDistrictTEC.value.text,
        location: null,
      ));
      //post
      final post = await dbService.createPostByCreatedByShipmentId(
        currentUser.id,
        shipment.id,
      );
      if (post == null) {
        Get.snackbar(
          'Failed:',
          'Could not create post for shipment',
          duration: const Duration(seconds: 2),
        );
      } else {
        shipment.shipmentAddressFrom = addressFrom;
        shipment.shipmentAddressTo = addressTo;
        shipmentItems.insert(
            0,
            ShipmentItem(
              shipment,
              initialKey: Key(shipment.id.toString()),
              onDeleteCallBack: () {
                shipmentItems.removeWhere(
                    (element) => element.key == Key(shipment.id.toString()));
              },
            ));
        shipmentsTotalCount.value++;
        notesTEC.update((val) {
          val?.clear();
        });
        Get.back();
        Get.snackbar(
          'Success:',
          'Created shipment',
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  Future<void> fetchShipmentsByConditionByFirstAfter() async {
    try {
      var condition = {
        'createdBy': currentUser.id,
        'deletedAt': null,
      };
      if (chipStatus.value != ShipmentStatus.undefined) {
        condition = {
          'createdBy': currentUser.id,
          'deletedAt': null,
          'status': chipStatus.value,
        };
      }
      var moreItems = await dbService.shipmentsByConditionByFirstAfter(
        condition,
        _limit,
        shipmentsPageInfo.value.endCursor,
      );
      if (moreItems != null) {
        shipmentsTotalCount.value = moreItems.totalCount;
        shipmentsPageInfo.value = moreItems.pageInfo ?? PageInfo();
        shipmentItems.addAll(moreItems.nodes.map((e) => ShipmentItem(
              e,
              initialKey: Key(e.id.toString()),
              onDeleteCallBack: () {
                shipmentItems.removeWhere(
                    (element) => element.key == Key(e.id.toString()));
              },
            )));
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }
}
