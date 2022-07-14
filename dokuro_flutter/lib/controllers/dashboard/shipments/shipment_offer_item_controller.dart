import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ShipmentOfferItemController {
  final ShipmentOffer initialShipmentOffer;
  final Shipment? intialShipment;
  final Function(ShipmentOffer shipmentOffer)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  ShipmentOfferItemController(
    this.initialShipmentOffer, {
    this.intialShipment,
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  });
  
  final dbService = Get.find<DbService>();
  final User currentUser = Get.find<AuthController>().authedUser.value!;
  final FocusNode offerPriceFC = FocusNode();
  final FocusNode offerNotesFC = FocusNode();

  Rx<TextEditingController> offerPriceTEC = TextEditingController().obs;
  Rx<TextEditingController> offerNotesTEC = TextEditingController().obs;
  Rx<Status> status = Status.ready.obs;

  void onDeleteTap() async {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Confirm:'),
          ],
        ),
        children: [
          // r u sure
          Row(children: const [
            SizedBox(width: 5),
            Flexible(child: Text('Are you sure to delete this offer?')),
          ]),
          const SizedBox(height: 10),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              // ok
              Flexible(
                child: TextButton(
                  onPressed: onDeleteSubmitTap,
                  child: const Text('Yes, delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onAcceptTap() async {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Confirm:'),
          ],
        ),
        children: [
          // r u sure
          Row(children: const [
            SizedBox(width: 5),
            Flexible(child: Text('Are you sure to accept this offer?')),
          ]),
          const SizedBox(height: 10),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              // ok
              Flexible(
                child: TextButton(
                  onPressed: onAcceptSubmitTap,
                  child: const Text('Yes, accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onRejectTap() async {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Confirm:'),
          ],
        ),
        children: [
          // r u sure
          Row(children: const [
            SizedBox(width: 5),
            Flexible(child: Text('Are you sure to reject this offer?')),
          ]),
          const SizedBox(height: 10),
          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel
              Flexible(
                child: ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              // ok
              Flexible(
                child: TextButton(
                  onPressed: onRejectSubmitTap,
                  child: const Text('Yes, reject'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onViewTap() {
    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(children: [
          Expanded(
            child: Stack(alignment: AlignmentDirectional.center, children: [
              const Text('Shipment Offer'),
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
          const Divider(thickness: 2),
          const SizedBox(width: 10),
          // avatar + name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: UserAvatar(
                  avatarUrl: initialShipmentOffer.userByCreatedBy?.avatarUrl,
                  lastSeen: initialShipmentOffer.userByCreatedBy?.lastSeen,
                ),
              ),
              const SizedBox(width: 5),
              UserName(name: initialShipmentOffer.userByCreatedBy?.name),
            ],
          ),
          const SizedBox(width: 5),
          // cod
          Text(
            'Price: ${initialShipmentOffer.price} vnđ',
            maxLines: 1,
          ),
          // notes
          Text(
            'Notes: ${initialShipmentOffer.notes}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ok
              Expanded(
                child: ElevatedButton(
                  onPressed: Get.back,
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onEditTap() {
    offerPriceTEC.value.text = initialShipmentOffer.price != 0
        ? initialShipmentOffer.price.toString()
        : '';
    offerNotesTEC.value.text = initialShipmentOffer.notes;

    Get.dialog(
      SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, .0),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        title: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Offer:'),
          const SizedBox(width: 10),
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
              child: UserAvatar(
                avatarUrl: initialShipmentOffer.userByCreatedBy?.avatarUrl,
                lastSeen: initialShipmentOffer.userByCreatedBy?.lastSeen,
              )),
          const SizedBox(width: 5),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // price
                Row(children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: Get.height / 4,
                        maxWidth: Get.width / 2 - 40),
                    child: Text(
                      'Price: ${int.tryParse(offerPriceTEC.value.text) ?? 0}',
                      style: const TextStyle(fontSize: 10),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'vnđ',
                    style: TextStyle(fontSize: 10),
                  ),
                ]),
                // notes
                Row(children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: Get.height / 4,
                        maxWidth: Get.width / 2 - 40),
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
        ]),
        children: [
          // price
          Row(children: [
            const SizedBox(width: 5),
            const Flexible(child: Text('Price: ')),
            Expanded(
              flex: 4,
              child: TextField(
                focusNode: offerPriceFC,
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
                focusNode: offerNotesFC,
                controller: offerNotesTEC.value,
                onChanged: (e) {
                  offerNotesTEC.update((val) {});
                },
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  constraints: const BoxConstraints(maxHeight: 35),
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
                onEditingComplete: onEditSubmitTap,
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
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              // ok
              Flexible(
                child: ElevatedButton(
                  onPressed: onEditSubmitTap,
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onDeleteSubmitTap() async {
    final deleted = await dbService.deleteShipmentOffer(
      initialShipmentOffer.id,
    );
    if (deleted == null) {
      Get.snackbar(
        'Failed:',
        'Could not delete offer',
        duration: const Duration(seconds: 2),
      );
    } else {
      onDeleteCallBack?.call();
      Get.back();
      Get.snackbar(
        'Success:',
        'Deleted offer',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onEditSubmitTap() async {
    final updated = await dbService.updateShipmentOfferByIdPriceNotesEditedAt(
      initialShipmentOffer.id,
      stringHelper.parsePrice(offerPriceTEC.value.text),
      offerNotesTEC.value.text.isNotEmpty ? offerNotesTEC.value.text : null,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not update offer',
        duration: const Duration(seconds: 2),
      );
    } else {
      initialShipmentOffer.price = updated.price;
      initialShipmentOffer.notes = updated.notes;
      initialShipmentOffer.editedAt = updated.editedAt;
      onUpdateCallBack?.call(updated);
      Get.back();
      Get.snackbar(
        'Success:',
        'Updated offer',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onAcceptSubmitTap() async {
    final updated = await dbService.updateShipmentOfferByIdAcceptedAt(
      initialShipmentOffer.id,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not accept offer',
        duration: const Duration(seconds: 2),
      );
    } else {
      onRefetchCallBack?.call();
      Get.back();
      Get.snackbar(
        'Success:',
        'Accepted offer',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> onRejectSubmitTap() async {
    final updated = await dbService.updateShipmentOfferByIdRejectedAt(
      initialShipmentOffer.id,
    );
    if (updated == null) {
      Get.snackbar(
        'Failed:',
        'Could not reject offer',
        duration: const Duration(seconds: 2),
      );
    } else {
      onUpdateCallBack?.call(updated);
      Get.back();
      Get.snackbar(
        'Success:',
        'Rejected offer',
        duration: const Duration(seconds: 2),
      );
    }
  }

  initPlz() {}

  disposePlz() {
    debugPrint('ShipmentOfferItemController dispose');
    offerPriceFC.dispose();
    offerNotesFC.dispose();
    offerPriceTEC.update((val) {
      val?.dispose();
    });
    offerNotesTEC.update((val) {
      val?.dispose();
    });
  }
}
