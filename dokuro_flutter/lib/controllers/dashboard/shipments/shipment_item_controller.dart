import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:dokuro_flutter/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:dokuro_flutter/controllers/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShipmentItemController {
  final Shipment initialShipment;
  final Function(Shipment shipment)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  ShipmentItemController(
    this.initialShipment, {
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  });

  final dbService = Get.find<DbService>();
  final User currentUser = Get.find<AuthController>().authedUser.value!;

  Rx<Status> status = Status.ready.obs;

  initPlz() {
    debugPrint('ShipmentItemController, id: ${initialShipment.id}');

    ever(status, (_) {
      debugPrint('status: $status');
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
                avatarUrl: initialShipment.userByCreatedBy?.avatarUrl,
                lastSeen: initialShipment.userByCreatedBy?.lastSeen,
              ),
            ),
            const SizedBox(width: 5),
            // name + uid
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserName(name: initialShipment.userByCreatedBy?.name),
                  TextButton.icon(
                    onPressed: () {
                      var uid = '';
                      if (initialShipment.userByCreatedBy?.uid.isNotEmpty ??
                          false) {
                        uid = initialShipment.userByCreatedBy!.uid;
                      } else {
                        uid = initialShipment.createdBy;
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
                    label: Text(
                        'uid: ${(initialShipment.userByCreatedBy?.uid.isNotEmpty ?? false) ? initialShipment.userByCreatedBy?.uid : initialShipment.createdBy}'),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 5),
          // type
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.delivery_dining),
            Flexible(child: Text('Type: ${initialShipment.type}')),
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
                child: Text(initialShipment.service),
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
                child: Text('${initialShipment.cod} vnđ'),
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
                child: Text(initialShipment.phone.isNotEmpty
                    ? initialShipment.phone
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
                child: Text(initialShipment.status),
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
}
