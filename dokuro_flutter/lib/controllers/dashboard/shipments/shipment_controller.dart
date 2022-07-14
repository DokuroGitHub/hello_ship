import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/data/shipment_query.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:dokuro_flutter/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShipmentController {
  final Shipment initialShipment;
  final Key? initialKey;
  final Function? onDeleteCallback;
  final Function? onRefreshCallBack;

  ShipmentController(
    this.initialShipment, {
    this.initialKey,
    this.onDeleteCallback,
    this.onRefreshCallBack,
  });

  final dbService = Get.find<DbService>();
  final _notificationService = Get.find<NotificationService>();
  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;
  Rx<Shipment> shipment = Shipment().obs;
  Rx<ShipmentOffers> shipmentOffers = ShipmentOffers().obs;
  Rx<TextEditingController> searchOfferTEC = TextEditingController().obs;
  Rx<TextEditingController> offerPriceTEC = TextEditingController().obs;
  Rx<TextEditingController> offerNotesTEC = TextEditingController().obs;

  // edit shipment
  Rx<TextEditingController> codTEC = TextEditingController().obs;
  Rx<TextEditingController> notesTEC = TextEditingController().obs;
  Rx<TextEditingController> phoneTEC = TextEditingController().obs;

  // shipmentOffers conditions
  RxBool cbCreatedByMe = false.obs;
  RxBool cbRejectedAt = false.obs;
  RxBool cbAcceptedAt = false.obs;
  RxBool cbAcceptedAtRejectedAtNull = false.obs;
  Rx<ShipmentOffersOrderBy> shipmentOffersOrderBy =
      ShipmentOffersOrderBy.newest.obs;

  RxInt stepperIndex = 0.obs;

  final shipmentStatuses = [
    ShipmentStatus.finding,
    ShipmentStatus.delivering,
    ShipmentStatus.delivered,
    ShipmentStatus.canceled,
  ];

  void initPlz() {
    debugPrint('$runtimeType, id: ${initialShipment.id}, key: $initialKey');
    shipment.value = initialShipment;
    fetchshipmentByIdForShipmentcreen();
    _subscriptioShipmentOffersByShipmentIdFirst();
  }

  void disposePlz() {
    debugPrint('$runtimeType disposePlz');
  }

  void sortShipmentOffers() {
    if (shipmentOffers.value.nodes.isEmpty) {
      return;
    }
    var items = shipmentOffers.value.nodes;
    // default newest
    if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.newest) {
      items.sort((a, b) =>
          (b.editedAt ?? b.createdAt)!.compareTo((a.editedAt ?? a.createdAt)!));
    } else if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.oldest) {
      items.sort((a, b) =>
          (a.editedAt ?? a.createdAt)!.compareTo((b.editedAt ?? b.createdAt)!));
    } else if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.priceAsc) {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (shipmentOffersOrderBy.value == ShipmentOffersOrderBy.priceDesc) {
      items.sort((a, b) => b.price.compareTo(a.price));
    }
    shipmentOffers.update((val) {
      val?.nodes = items;
    });
  }

  void onShipmentViewTap() {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              const Text('Shipment'),
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
          // avatar + name + uid
          Row(children: [
            // avatar
            SizedBox(
              width: 40,
              height: 40,
              child: UserAvatar(
                avatarUrl: shipment.value.userByCreatedBy?.avatarUrl,
                lastSeen: shipment.value.userByCreatedBy?.lastSeen,
              ),
            ),
            const SizedBox(width: 5),
            // name + uid
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserName(name: shipment.value.userByCreatedBy?.name),
                  TextButton.icon(
                    onPressed: () {
                      var uid = '';
                      if (shipment.value.userByCreatedBy?.uid.isNotEmpty ??
                          false) {
                        uid = shipment.value.userByCreatedBy!.uid;
                      } else {
                        uid = shipment.value.createdBy;
                      }
                      final message = 'uid: $uid';
                      Clipboard.setData(ClipboardData(text: uid));
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
                    label: Obx(() => Text(
                        'uid: ${(shipment.value.userByCreatedBy?.uid.isNotEmpty ?? false) ? shipment.value.userByCreatedBy?.uid : shipment.value.createdBy}')),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // type
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.delivery_dining),
            Flexible(child: Text('Type: ${shipment.value.type}')),
          ]),
          const SizedBox(height: 5),
          // service
          Row(children: [
            const Icon(Icons.category),
            const Flexible(child: Text('Service: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(shipment.value.service),
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // cod
          Row(children: [
            const Icon(Icons.attach_money),
            const Flexible(child: Text('Price: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text('${shipment.value.cod} vnđ'),
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // phone
          Row(children: [
            const Icon(Icons.phone),
            Flexible(
                child: Text('${AppLocalizations.of(Get.context!).phoneCap}: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(shipment.value.phone.isNotEmpty
                    ? shipment.value.phone
                    : AppLocalizations.of(Get.context!).phoneNot),
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // status
          Row(children: [
            const Icon(Icons.timer),
            const Flexible(child: Text('Status: ')),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(shipment.value.status),
              ),
            ),
          ]),

          const Divider(thickness: 1.0),
          // action buttons
          Row(children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Đóng'),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void onShipmentEditTap() {
    codTEC.value.text = shipment.value.cod.toString();
    notesTEC.value.text = shipment.value.notes;
    phoneTEC.value.text = shipment.value.phone;
    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              const Text('Edit shipment'),
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
          // cod
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Icon(Icons.attach_money),
            Flexible(child: Text('Price:')),
          ]),
          TextField(
            controller: codTEC.value,
            onChanged: (val) {
              codTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Giá',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 50,
            maxLines: 1,
          ),
          // notes
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.edit),
            Flexible(
                child: Text('${AppLocalizations.of(Get.context!).notesCap}:')),
          ]),
          TextField(
            controller: notesTEC.value,
            onChanged: (val) {
              notesTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Notes',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 50,
            maxLines: 1,
          ),
          // phone
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.phone),
            Flexible(
                child: Text('${AppLocalizations.of(Get.context!).phoneCap}:')),
          ]),
          TextField(
            controller: phoneTEC.value,
            onChanged: (val) {
              phoneTEC.update((val) {});
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'SĐT',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            maxLength: 50,
            maxLines: 1,
          ),

          // saveCap
          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                onPressed: _onShipmentEditSubmitTap,
                child: Text(AppLocalizations.of(Get.context!).saveCap),
              ),
            )
          ]),
        ],
      ),
    );
  }

  Future<void> onShipmentDeleteTap() async {
    Get.dialog(
      SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              const Text('Confirm'),
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
          // Are you sure
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Icon(Icons.question_mark),
            Flexible(child: Text('Are you sure to delete this?')),
          ]),
          const SizedBox(height: 20),

          // cancel+ok
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(AppLocalizations.of(Get.context!).cancel),
              ),
            ),
            Flexible(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                onPressed: _onShipmentDeleteSubmitTap,
                child: Text(AppLocalizations.of(Get.context!).ok),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> onOfferSearchTap() async {
    final items = await dbService.shipmentOffersByShipmentIdSearch(
      shipment.value.id,
      searchOfferTEC.value.text,
    );
    if (items == null) {
      Get.snackbar(
        'Failed:',
        'Could not search offers',
        duration: const Duration(seconds: 2),
      );
    } else {
      shipmentOffers.value = items;
      sortShipmentOffers();
      searchOfferTEC.update((val) {
        val?.clear();
      });
      Get.snackbar(
        'Success:',
        'fetched offers',
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onOfferTap() {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Flexible(child: Text('Offer:')),
          const SizedBox(width: 10),
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
              child: UserAvatar(
                avatarUrl: currentUser.avatarUrl,
                isOnline: true,
              )),
          const SizedBox(width: 5),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // price
                  Row(children: [
                    Expanded(
                      child: Text(
                        'Price: ${int.tryParse(offerPriceTEC.value.text) ?? 0} vnđ',
                        style: const TextStyle(
                          fontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ]),
                  // notes
                  Row(children: [
                    Expanded(
                      child: Text(
                        'Notes: ${offerNotesTEC.value.text}',
                        style: const TextStyle(fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ]),
        children: [
          // price
          Row(children: [
            const SizedBox(width: 5),
            const Flexible(child: Text('Price: ')),
            Expanded(
              flex: 4,
              child: TextField(
                controller: offerPriceTEC.value,
                onChanged: (s) {
                  offerPriceTEC.update((val) {});
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 35),
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 10, right: 0, bottom: 10),
                  hintText: '50000',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Flexible(child: Text('vnđ')),
          ]),
          const SizedBox(height: 5),
          // notes
          Row(children: [
            const SizedBox(width: 5),
            const Flexible(child: Text('Notes: ')),
            Expanded(
              flex: 4,
              child: TextField(
                controller: offerNotesTEC.value,
                onChanged: (e) {
                  offerNotesTEC.update((val) {});
                },
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 10, right: 10, bottom: 10),
                  hintText: 'Leave some notes here',
                  filled: true,
                  fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onEditingComplete: onOfferSubmitTap,
              ),
            ),
            const SizedBox(width: 5),
          ]),
          const SizedBox(height: 5),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: TextButton(
                  onPressed: () {
                    offerPriceTEC.update((val) {
                      val?.clear();
                    });
                    offerNotesTEC.update((val) {
                      val?.clear();
                    });
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              // ok
              Flexible(
                child: ElevatedButton(
                  onPressed: onOfferSubmitTap,
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onCancelTap() {
    Get.dialog(SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      titlePadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      title: Row(children: [
        Expanded(
          child: Stack(alignment: AlignmentDirectional.center, children: [
            const Text('Confirm'),
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
                  onPressed: Get.back,
                ),
              ),
            ),
          ]),
        )
      ]),
      children: [
        const Divider(thickness: 1.0),
        const Text('Are you sure?'),
        const SizedBox(height: 30),
        // action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // cancel
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('No'),
              ),
            ),
            // ok
            Flexible(
              child: TextButton(
                onPressed: () async {
                  Get.back();
                  await onUpdateShipmentByIdStatus(ShipmentStatus.canceled);
                },
                child: const Text('Yes'),
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Future<void> onOfferSubmitTap() async {
    final created =
        await dbService.createShipmentOfferByShipmentIdCreatedByPriceNotes(
      shipment.value.id,
      currentUser.id,
      int.tryParse(offerPriceTEC.value.text),
      offerNotesTEC.value.text.isNotEmpty ? offerNotesTEC.value.text : null,
    );
    if (created == null) {
      Get.snackbar(
        'Failed:',
        'Could not send offer',
        duration: const Duration(seconds: 2),
      );
    } else {
      shipmentOffers.update((val) {
        val?.nodes.add(created);
        val?.totalCount++;
      });
      sortShipmentOffers();
      offerPriceTEC.update((val) {
        val?.clear();
      });
      offerNotesTEC.update((val) {
        val?.clear();
      });
      Get.back();
      Get.snackbar(
        'Success:',
        'Sent offer',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onUpdateShipmentByIdStatus(String status) async {
    final updated = await dbService.updateShipmentByIdStatus(
      shipment.value.id,
      status,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update',
        duration: const Duration(seconds: 2),
      );
    } else {
      shipment.update((val) {
        val?.status = updated.status;
      });
      Get.snackbar(
        'Success:',
        'Updated successfully',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> fetchshipmentByIdForShipmentcreen() async {
    try {
      final item = await dbService.shipmentByIdForShipmentcreen(
        shipment.value.id,
      );
      if (item != null) {
        shipment.value = item;
        if (shipment.value.shipmentOffers != null) {
          shipmentOffers.value = shipment.value.shipmentOffers!;
        }
      }
    } catch (e) {
      debugPrint('e: $e');
    }
  }

  Future<void> _onShipmentEditSubmitTap() async {
    final updated = await dbService.updateShipmentByIdCodNotesPhoneEditedAt(
      shipment.value.id,
      codTEC.value.text.isNotEmpty
          ? int.tryParse(codTEC.value.text) ?? 0
          : null,
      notesTEC.value.text.isNotEmpty ? notesTEC.value.text : null,
      phoneTEC.value.text.isNotEmpty ? phoneTEC.value.text : null,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update',
        duration: const Duration(seconds: 2),
      );
    } else {
      shipment.update((val) {
        val?.cod = updated.cod;
        val?.notes = updated.notes;
        val?.phone = updated.phone;
        val?.editedAt = updated.editedAt;
      });
      Get.back();
      Get.snackbar(
        'Success:',
        'Updated successfully',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _onShipmentDeleteSubmitTap() async {
    final updated = await dbService.updateShipmentByIdDeletedAt(
      shipment.value.id,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not delete',
        duration: const Duration(seconds: 2),
      );
    } else {
      shipment.update((val) {
        val?.deletedAt = updated.deletedAt;
      });
      onDeleteCallback?.call();
      Get.back();
      Get.snackbar(
        'Success:',
        'Deleted successfully',
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _subscriptioShipmentOffersByShipmentIdFirst() {
    if (dbService.client != null) {
      return;
    }
    try {
      var subscription = dbService.client!.subscribe(
        SubscriptionOptions(
          document: gql(ShipmentQuery.shipmentOffersByShipmentIdFirst),
          variables: {
            'shipmentId': shipment.value.id,
            'first': 1,
          },
        ),
      );
      subscription.listen((result) {
        if (result.hasException) {
          debugPrint(result.exception.toString());
          return;
        }
        if (result.isLoading) {
          debugPrint('awaiting results');
          return;
        }
        final map = result.data?['shipmentOffersByShipmentId'];
        debugPrint('data: ${result.data}');
        if (map != null) {
          final items = convertMapToShipmentOffers(map);
          if (items != null && items.nodes.isNotEmpty) {
            final item = items.nodes.first;
            _notificationService.flutterLocalNotificationsPlugin.show(
              0,
              'New Offer From Shipment id: ${item.shipmentId}',
              'Offer: ${item.price} vnđ, text: ${item.notes}',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'hello_ship_notifications',
                  'hello ship notifications desu',
                  channelDescription: 'Hello Ship Notifications',
                  importance: Importance.max,
                  priority: Priority.high,
                  ticker: 'ticker',
                ),
              ),
              payload: 'shipmentId:${item.shipmentId}',
            );
          }
        }
      });
    } catch (e) {
      debugPrint('e: $e');
    }
  }
}
