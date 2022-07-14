import 'package:dokuro_flutter/controllers/dashboard/shipments/shipment_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/shipment/shipment_attachments_widget.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/shipment/shipment_offer_item.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShipmentScreen extends StatefulWidget {
  final Shipment initialShipment;
  final Function? onDeleteCallback;
  const ShipmentScreen(
    this.initialShipment, {
    Key? initialKey,
    this.onDeleteCallback,
  }) : super(key: initialKey);

  @override
  State<ShipmentScreen> createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  late final shipmentController = ShipmentController(
    widget.initialShipment,
    onDeleteCallback: widget.onDeleteCallback,
  );

  @override
  void initState() {
    shipmentController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    shipmentController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ShipmentScreen');
    return Scaffold(
      appBar: _appBar(),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Obx(() => _stepper()),
              const SizedBox(height: 10),
              Obx(() => _changeShipmentStatus()),
              const Divider(thickness: 1),
              _avatar(),
              const SizedBox(height: 10),
              _addressFrom(),
              const SizedBox(height: 10),
              _addressTo(),
              const SizedBox(height: 10),
              _createdAt(),
              const SizedBox(height: 10),
              _editedAt(),
              const SizedBox(height: 10),
              _type(),
              const SizedBox(height: 10),
              _service(),
              const SizedBox(height: 10),
              _notes(),
              const SizedBox(height: 10),
              _phone(),
              const SizedBox(height: 10),
              _cod(),
              const SizedBox(height: 10),
              _status(),
              const SizedBox(height: 10),
              _shipmentAttachments(),
              const SizedBox(height: 10),
              _shipmentOffers(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0.0,
      title: Text('Chi tiết Shipment',
          style: Theme.of(Get.context!).appBarTheme.titleTextStyle),
      actions: [
        if (1 == 2)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
          ),
        _actions(),
      ],
    );
  }

  Widget _stepper() {
    if (shipmentController.shipment.value.status == ShipmentStatus.finding) {
      return Column(
        children: [
          Row(children: [
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 15,
                child: Text('1', style: TextStyle(color: Colors.white)),
              ),
              label: const Text(
                ShipmentStatus.finding,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Expanded(
                child: Divider(
              height: 5,
              color: Colors.grey,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
                child: Text('2', style: TextStyle(color: Colors.white)),
              ),
              label: const Text(ShipmentStatus.delivering),
            ),
            const Expanded(
                child: Divider(
              height: 5,
              color: Colors.grey,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
                child: Text('3', style: TextStyle(color: Colors.white)),
              ),
              label: const Text(ShipmentStatus.delivered),
            ),
          ]),
          const Text('Đang tìm shipper'),
        ],
      );
    } else if (shipmentController.shipment.value.status ==
        ShipmentStatus.delivering) {
      return Column(
        children: [
          Row(children: [
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.green,
                radius: 15,
                child: Icon(Icons.check, color: Colors.white),
              ),
              label: const Text(
                ShipmentStatus.finding,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Expanded(
                child: Divider(
              thickness: 5,
              color: Colors.green,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 15,
                child: Text('2', style: TextStyle(color: Colors.white)),
              ),
              label: const Text(ShipmentStatus.delivering),
            ),
            const Expanded(
                child: Divider(
              thickness: 5,
              color: Colors.grey,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15,
                child: Text('3', style: TextStyle(color: Colors.white)),
              ),
              label: const Text(
                ShipmentStatus.delivered,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
          const Text('Đang vận chuyển'),
        ],
      );
    } else if (shipmentController.shipment.value.status ==
        ShipmentStatus.delivered) {
      return Column(
        children: [
          Row(children: [
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.green,
                radius: 15,
                child: Icon(Icons.check, color: Colors.white),
              ),
              label: const Text(
                ShipmentStatus.finding,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Expanded(
                child: Divider(
              thickness: 5,
              color: Colors.green,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.green,
                radius: 15,
                child: Icon(Icons.check, color: Colors.white),
              ),
              label: const Text(
                ShipmentStatus.delivering,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Expanded(
                child: Divider(
              thickness: 5,
              color: Colors.green,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.green,
                radius: 15,
                child: Icon(Icons.check, color: Colors.white),
              ),
              label: const Text(
                ShipmentStatus.delivered,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
          const Text('Vận chuyển hoàn tất'),
        ],
      );
    } else if (shipmentController.shipment.value.status ==
        ShipmentStatus.canceled) {
      return Column(
        children: [
          Row(children: [
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(Icons.error, color: Colors.red),
              ),
              label: const Text(ShipmentStatus.finding),
            ),
            const Expanded(
                child: Divider(
              height: 5,
              color: Colors.grey,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(Icons.error, color: Colors.red),
              ),
              label: const Text(ShipmentStatus.delivering),
            ),
            const Expanded(
                child: Divider(
              height: 5,
              color: Colors.grey,
            )),
            TextButton.icon(
              onPressed: () {},
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(Icons.error, color: Colors.red),
              ),
              label: const Text(ShipmentStatus.delivered),
            ),
          ]),
          const Text('Shipment đã huỷ'),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _changeShipmentStatus() {
    debugPrint('createdBy ${shipmentController.shipment.value.createdBy}');
    debugPrint('currentUser ${shipmentController.currentUser.id}');
    if (shipmentController.shipment.value.acceptedOffer?.createdBy ==
            shipmentController.currentUser.id &&
        shipmentController.shipment.value.status != ShipmentStatus.delivered) {
      return Row(children: [
        Expanded(
            child: ElevatedButton(
          onPressed: () {
            if (shipmentController.shipment.value.status ==
                ShipmentStatus.delivering) {
              shipmentController
                  .onUpdateShipmentByIdStatus(ShipmentStatus.delivered);
            }
          },
          child: const Text('Tiếp tục'),
        )),
      ]);
    }
    if (shipmentController.shipment.value.createdBy ==
            shipmentController.currentUser.id &&
        (shipmentController.shipment.value.status == ShipmentStatus.finding ||
            shipmentController.shipment.value.status ==
                ShipmentStatus.delivering)) {
      return TextButton(
        onPressed: () {
          shipmentController.onCancelTap();
        },
        child: const Text('Huỷ'),
      );
    }

    return const SizedBox();
  }

  Widget _avatar() {
    return Row(children: [
      // avatar
      SizedBox(
        width: 40,
        height: 40,
        child: UserAvatar(
          avatarUrl:
              shipmentController.shipment.value.userByCreatedBy?.avatarUrl,
          lastSeen: shipmentController.shipment.value.userByCreatedBy?.lastSeen,
        ),
      ),
      const SizedBox(width: 5),
      // name + uid
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserName(
                name: shipmentController.shipment.value.userByCreatedBy?.name),
            TextButton.icon(
              onPressed: () {
                var uid = '';
                if (shipmentController
                        .shipment.value.userByCreatedBy?.uid.isNotEmpty ??
                    false) {
                  uid = shipmentController.shipment.value.userByCreatedBy!.uid;
                } else {
                  uid = shipmentController.shipment.value.createdBy;
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
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              ),
              icon: const Icon(Icons.person),
              label: Text(
                  'uid: ${shipmentController.shipment.value.userByCreatedBy?.uid}'),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _addressFrom() {
    if (shipmentController.shipment.value.shipmentAddressFrom == null) {
      //return const SizedBox();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text('Bắt đầu:'),
      ),
      const SizedBox(height: 5),
      Row(children: [
        const SizedBox(width: 20),
        const Icon(Icons.location_pin),
        const SizedBox(width: 10),
        Expanded(
          child: Text(stringHelper
              .addressToStringV3(
                  shipmentAddressFrom:
                      shipmentController.shipment.value.shipmentAddressFrom)
              .replaceAll(',,', ',')),
        ),
      ]),
    ]);
  }

  Widget _addressTo() {
    if (shipmentController.shipment.value.shipmentAddressTo == null) {
      //return const SizedBox();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text('Đến:'),
      ),
      const SizedBox(height: 5),
      Row(children: [
        const SizedBox(width: 20),
        const Icon(Icons.location_pin),
        const SizedBox(width: 10),
        Expanded(
          child: Text(stringHelper
              .addressToStringV3(
                  shipmentAddressTo:
                      shipmentController.shipment.value.shipmentAddressTo)
              .replaceAll(',,', ',')),
        ),
      ]),
    ]);
  }

  Widget _notes() {
    if (shipmentController.shipment.value.notes.isEmpty) {
      return const SizedBox();
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.edit),
      const SizedBox(width: 10),
      Expanded(
          child: Text(
        'Notes: ${shipmentController.shipment.value.notes}',
        maxLines: 5,
      ))
    ]);
  }

  Widget _phone() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.phone),
      const SizedBox(width: 10),
      Flexible(child: Text('${AppLocalizations.of(Get.context!).phoneCap}: ')),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Text(shipmentController.shipment.value.phone.isNotEmpty
              ? shipmentController.shipment.value.phone
              : AppLocalizations.of(Get.context!).phoneNot),
        ),
      ),
    ]);
  }

  Widget _type() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.delivery_dining),
      const SizedBox(width: 10),
      const Flexible(child: Text('Type: ')),
      Flexible(
        child: Text(shipmentController.shipment.value.type),
      ),
    ]);
  }

  Widget _service() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.category),
      const SizedBox(width: 10),
      const Flexible(child: Text('Service: ')),
      Flexible(
        child: Text(shipmentController.shipment.value.service),
      ),
    ]);
  }

  Widget _status() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.timer),
      const SizedBox(width: 10),
      const Flexible(child: Text('Status: ')),
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Text(shipmentController.shipment.value.status),
        ),
      ),
    ]);
  }

  Widget _cod() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.attach_money),
      const SizedBox(width: 10),
      Expanded(
          child: Text('Price: ${shipmentController.shipment.value.cod} vnđ'))
    ]);
  }

  Widget _createdAt() {
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
            'Created at: ${stringHelper.dateTimeToStringV5(shipmentController.shipment.value.createdAt)}'),
      ),
    ]);
  }

  Widget _editedAt() {
    if (shipmentController.shipment.value.editedAt == null) {
      return const SizedBox();
    }
    return Row(children: [
      const SizedBox(width: 10),
      const Icon(Icons.date_range_outlined),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
            'Edited at: ${stringHelper.dateTimeToStringV5(shipmentController.shipment.value.editedAt)}'),
      ),
    ]);
  }

  Widget _shipmentAttachments() {
    if (shipmentController.shipment.value.shipmentAttachments?.nodes.isEmpty ??
        true) {
      return const SizedBox();
    }
    return Column(children: [
      Row(children: const [
        SizedBox(width: 10),
        Icon(Icons.date_range_outlined),
        SizedBox(width: 10),
        Flexible(
          child: Text('Attachments:'),
        ),
      ]),
      Row(
        children: [
          Expanded(
            child: ShipmentAttachmentsWidget(
                attachments:
                    shipmentController.shipment.value.shipmentAttachments!),
          ),
        ],
      ),
    ]);
  }

  Widget _shipmentOffers() {
    var items = shipmentController.shipmentOffers.value.nodes;
    if (shipmentController.cbCreatedByMe.value) {
      items = items
          .where((element) =>
              element.createdBy == shipmentController.currentUser.id)
          .toList();
    }
    if (shipmentController.cbAcceptedAt.value) {
      items = items.where((element) => element.acceptedAt != null).toList();
    }
    if (shipmentController.cbRejectedAt.value) {
      items = items
          .where((element) =>
              element.rejectedAt != null && element.acceptedAt == null)
          .toList();
    }
    if (shipmentController.cbAcceptedAtRejectedAtNull.value) {
      items = items
          .where((element) =>
              element.acceptedAt == null && element.rejectedAt == null)
          .toList();
    }
    final search = shipmentController.searchOfferTEC.value.text.toLowerCase();
    if (search.isNotEmpty) {
      items = items
          .where((element) =>
              element.price.toString().contains(search) ||
              element.notes.toLowerCase().contains(search) ||
              (element.userByCreatedBy?.uid.toLowerCase().contains(search) ??
                  false) ||
              (element.userByCreatedBy?.name.toLowerCase().contains(search) ??
                  false))
          .toList();
    }

    return Column(children: [
      _searchOfferRow(),
      const SizedBox(height: 5),
      // list offers
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: Get.height / 4),
        child: ListView(
          shrinkWrap: true,
          children: [
            //for (var i = 0; i < 5; i++)
            ...items.map((e) => ShipmentOfferItem(
                  e,
                  initialShipment: shipmentController.shipment.value,
                  onUpdateCallBack: (shipmentOffer) {
                    shipmentController.shipmentOffers.update((val) {
                      val?.nodes.remove(e);
                      val?.nodes.add(shipmentOffer);
                    });
                    shipmentController.sortShipmentOffers();
                  },
                  onDeleteCallBack: () {
                    shipmentController.shipmentOffers.update((val) {
                      val?.nodes.remove(e);
                      val?.totalCount--;
                    });
                  },
                  onRefetchCallBack: () async {
                    await shipmentController
                        .fetchshipmentByIdForShipmentcreen();
                    if (shipmentController.shipment.value.shipmentOffers !=
                        null) {
                      shipmentController.shipmentOffers.value =
                          shipmentController.shipment.value.shipmentOffers!;
                    }
                    shipmentController.sortShipmentOffers();
                  },
                )),
          ],
        ),
      ),
      // buttons // acceptedOffer
      shipmentController.shipment.value.acceptedOffer == null
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                child: TextButton(
                  onPressed: shipmentController.onOfferTap,
                  child: const Text('Offer'),
                ),
              ),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Winner:'),
              ShipmentOfferItem(
                shipmentController.shipment.value.acceptedOffer!,
              ),
            ]),

      const Divider(thickness: 1.5),
    ]);
  }

  Widget _searchOfferRow() {
    return Row(
      children: [
        const Text('+ Offers: '),
        // searchTF
        Expanded(
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              // phim enter => send
              if (event.runtimeType == RawKeyDownEvent &&
                  (event.logicalKey.keyId == 4294967309) &&
                  (!event.isShiftPressed)) {
                shipmentController.onOfferSearchTap();
              }
            },
            child: TextField(
              controller: shipmentController.searchOfferTEC.value,
              minLines: 1,
              maxLines: 1,
              onChanged: (s) {
                shipmentController.searchOfferTEC.update((val) {});
              },
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 35),
                contentPadding: const EdgeInsets.only(
                    left: 10.0, top: 10, right: 0, bottom: 10),
                hintText: 'Tìm kiếm',
                filled: true,
                fillColor: Theme.of(Get.context!).bannerTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    // send button => send
                    onPressed: shipmentController.onOfferSearchTap,
                  ),
                ]),
              ),
            ),
          ),
        ),
        // filter
        IconButton(
          onPressed: () {
            Get.dialog(SimpleDialog(
              title: const Text('Lọc'),
              children: [
                // cbCreatedByMe
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        shipmentController.cbCreatedByMe.value =
                            !shipmentController.cbCreatedByMe.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: shipmentController.cbCreatedByMe.value,
                              onChanged: null)),
                        ),
                        const Text('Của tôi'),
                      ]),
                    ),
                  ),
                ]),
                // cbAcceptedAt
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        shipmentController.cbAcceptedAt.value =
                            !shipmentController.cbAcceptedAt.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: shipmentController.cbAcceptedAt.value,
                              onChanged: null)),
                        ),
                        const Text('Accepted'),
                      ]),
                    ),
                  ),
                ]),
                // cbRejectedAt
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        shipmentController.cbRejectedAt.value =
                            !shipmentController.cbRejectedAt.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: shipmentController.cbRejectedAt.value,
                              onChanged: null)),
                        ),
                        const Text('Rejected'),
                      ]),
                    ),
                  ),
                ]),
                // cbAcceptedAtRejectedAtNull
                Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        shipmentController.cbAcceptedAtRejectedAtNull.value =
                            !shipmentController
                                .cbAcceptedAtRejectedAtNull.value;
                      },
                      child: Row(children: [
                        IgnorePointer(
                          child: Obx(() => Checkbox(
                              value: shipmentController
                                  .cbAcceptedAtRejectedAtNull.value,
                              onChanged: null)),
                        ),
                        const Text('Not decided'),
                      ]),
                    ),
                  ),
                ]),
              ],
            ));
          },
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
          ),
        ),
        // sort
        PopupMenuButton<ShipmentOffersOrderBy>(
          tooltip: 'Xếp theo',
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
          ),
          onSelected: (selected) {
            shipmentController.shipmentOffersOrderBy.value = selected;
            shipmentController.sortShipmentOffers();
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.oldest,
                child: Text('Cũ nhất',
                    style: TextStyle(
                        color: shipmentController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.oldest
                            ? Colors.red
                            : Colors.blue)),
              ),
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.newest,
                child: Text('Mới nhất',
                    style: TextStyle(
                        color: shipmentController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.newest
                            ? Colors.red
                            : Colors.blue)),
              ),
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.priceDesc,
                child: Text('Giá cao nhất',
                    style: TextStyle(
                        color: shipmentController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.priceDesc
                            ? Colors.red
                            : Colors.blue)),
              ),
              PopupMenuItem<ShipmentOffersOrderBy>(
                value: ShipmentOffersOrderBy.priceAsc,
                child: Text('Giá thấp nhất',
                    style: TextStyle(
                        color: shipmentController.shipmentOffersOrderBy.value ==
                                ShipmentOffersOrderBy.priceAsc
                            ? Colors.red
                            : Colors.blue)),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _actions() {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
      ),
      onSelected: (selected) {
        if (selected == 'view') {
          shipmentController.onShipmentViewTap();
        } else if (selected == 'edit') {
          shipmentController.onShipmentEditTap();
        } else if (selected == 'delete') {
          shipmentController.onShipmentDeleteTap();
        } else if (selected == ShipmentStatus.finding) {
          shipmentController.onUpdateShipmentByIdStatus(ShipmentStatus.finding);
        } else if (selected == ShipmentStatus.delivering) {
          shipmentController
              .onUpdateShipmentByIdStatus(ShipmentStatus.delivering);
        } else if (selected == ShipmentStatus.delivered) {
          shipmentController
              .onUpdateShipmentByIdStatus(ShipmentStatus.delivered);
        } else if (selected == ShipmentStatus.canceled) {
          shipmentController
              .onUpdateShipmentByIdStatus(ShipmentStatus.canceled);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'view',
            child: Text('View'),
          ),
          if (shipmentController.shipment.value.createdBy ==
              shipmentController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
          if (shipmentController.shipment.value.createdBy ==
              shipmentController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          if (shipmentController.shipment.value.createdBy ==
              shipmentController.currentUser.id)
            const PopupMenuItem<String>(
              value: ShipmentStatus.finding,
              child: Text(ShipmentStatus.finding),
            ),
          if (shipmentController.shipment.value.createdBy ==
              shipmentController.currentUser.id)
            const PopupMenuItem<String>(
              value: ShipmentStatus.delivering,
              child: Text(ShipmentStatus.delivering),
            ),
          if (shipmentController.shipment.value.createdBy ==
              shipmentController.currentUser.id)
            const PopupMenuItem<String>(
              value: ShipmentStatus.delivered,
              child: Text(ShipmentStatus.delivered),
            ),
          if (shipmentController.shipment.value.createdBy ==
              shipmentController.currentUser.id)
            const PopupMenuItem<String>(
              value: ShipmentStatus.canceled,
              child: Text(ShipmentStatus.canceled),
            ),
        ];
      },
    );
  }
}
