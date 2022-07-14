import 'package:dokuro_flutter/controllers/dashboard/shipments/shipments_for_shipper_controller.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShipmentsForShipperScreen extends StatefulWidget {
  const ShipmentsForShipperScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentsForShipperScreen> createState() =>
      _ShipmentsForShipperScreenState();
}

class _ShipmentsForShipperScreenState extends State<ShipmentsForShipperScreen> {
  final shipmentsForShipperController = ShipmentsForShipperController();

  @override
  void initState() {
    shipmentsForShipperController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    shipmentsForShipperController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('${widget.runtimeType}');
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        controller: shipmentsForShipperController.scrollController,
        child: Column(
          children: [
            _chips(),
            _shipments(),
            Obx(() => _more()),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0.0,
      title: Text('Shipments',
          style: Theme.of(Get.context!).appBarTheme.titleTextStyle),
      actions: [
        if (1 == 2)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
          ),
      ],
    );
  }

  Widget _chips() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              const Text(
                'Tag:',
                style: TextStyle(color: Colors.blue),
              ),
              // finding
              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (shipmentsForShipperController.chipStatus.value ==
                        ShipmentStatus.finding) {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.finding;
                    }
                    shipmentsForShipperController.resetShipments();
                    shipmentsForShipperController
                        .fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter();
                  },
                  child: shipmentsForShipperController.chipStatus.value ==
                          ShipmentStatus.finding
                      ? const Chip(
                          backgroundColor: Colors.blue,
                          avatar: CircleAvatar(
                            child: Icon(Icons.check_circle_outline,
                                color: Colors.green),
                          ),
                          label: Text(ShipmentStatus.finding),
                        )
                      : const Chip(
                          backgroundColor: Colors.grey,
                          avatar: CircleAvatar(
                            child: Icon(Icons.radio_button_unchecked),
                          ),
                          label: Text(
                            (ShipmentStatus.finding),
                          ),
                        ),
                ),
              ),
              // delivering
              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (shipmentsForShipperController.chipStatus.value ==
                        ShipmentStatus.delivering) {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.delivering;
                    }
                    shipmentsForShipperController.resetShipments();
                    shipmentsForShipperController
                        .fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter();
                  },
                  child: shipmentsForShipperController.chipStatus.value ==
                          ShipmentStatus.delivering
                      ? const Chip(
                          backgroundColor: Colors.blue,
                          avatar: CircleAvatar(
                            child: Icon(Icons.check_circle_outline,
                                color: Colors.green),
                          ),
                          label: Text(ShipmentStatus.delivering),
                        )
                      : const Chip(
                          backgroundColor: Colors.grey,
                          avatar: CircleAvatar(
                            child: Icon(Icons.radio_button_unchecked),
                          ),
                          label: Text(
                            (ShipmentStatus.delivering),
                          ),
                        ),
                ),
              ),
              // delivered
              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (shipmentsForShipperController.chipStatus.value ==
                        ShipmentStatus.delivered) {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.delivered;
                    }
                    shipmentsForShipperController.resetShipments();
                    shipmentsForShipperController
                        .fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter();
                  },
                  child: shipmentsForShipperController.chipStatus.value ==
                          ShipmentStatus.delivered
                      ? const Chip(
                          backgroundColor: Colors.blue,
                          avatar: CircleAvatar(
                            child: Icon(Icons.check_circle_outline,
                                color: Colors.green),
                          ),
                          label: Text(ShipmentStatus.delivered),
                        )
                      : const Chip(
                          backgroundColor: Colors.grey,
                          avatar: CircleAvatar(
                            child: Icon(Icons.radio_button_unchecked),
                          ),
                          label: Text(
                            (ShipmentStatus.delivered),
                          ),
                        ),
                ),
              ),
              // canceled
              Obx(
                () => GestureDetector(
                  onTap: () {
                    if (shipmentsForShipperController.chipStatus.value ==
                        ShipmentStatus.canceled) {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForShipperController.chipStatus.value =
                          ShipmentStatus.canceled;
                    }
                    shipmentsForShipperController.resetShipments();
                    shipmentsForShipperController
                        .fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter();
                  },
                  child: shipmentsForShipperController.chipStatus.value ==
                          ShipmentStatus.canceled
                      ? const Chip(
                          backgroundColor: Colors.blue,
                          avatar: CircleAvatar(
                            child: Icon(Icons.check_circle_outline,
                                color: Colors.green),
                          ),
                          label: Text(ShipmentStatus.canceled),
                        )
                      : const Chip(
                          backgroundColor: Colors.grey,
                          avatar: CircleAvatar(
                            child: Icon(Icons.radio_button_unchecked),
                          ),
                          label: Text(
                            (ShipmentStatus.canceled),
                          ),
                        ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _shipments() {
    debugPrint('_shipments');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return shipmentsForShipperController.shipmentItems[index];
          },
          itemCount: shipmentsForShipperController.shipmentItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      shipmentsForShipperController.shipmentItems.length !=
              shipmentsForShipperController.shipmentsTotalCount.value
          ? TextButton(
              onPressed: () {
                shipmentsForShipperController
                    .fetchShipmentsByShipmentOffersByCurrentUserIdConditionFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${shipmentsForShipperController.shipmentItems.length}/${shipmentsForShipperController.shipmentsTotalCount.value}'),
    ]);
  }
}
