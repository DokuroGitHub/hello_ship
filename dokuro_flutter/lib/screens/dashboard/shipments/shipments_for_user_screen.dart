import 'package:dokuro_flutter/controllers/dashboard/shipments/shipments_for_user_controller.dart';
import 'package:dokuro_flutter/models/constants/shipment_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShipmentsForUserScreen extends StatefulWidget {
  const ShipmentsForUserScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentsForUserScreen> createState() => _ShipmentsForUserScreenState();
}

class _ShipmentsForUserScreenState extends State<ShipmentsForUserScreen> {
  final shipmentsForUserController = ShipmentsForUserController();

  @override
  void initState() {
    shipmentsForUserController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    shipmentsForUserController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$runtimeType build');
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        controller: shipmentsForUserController.scrollController,
        child: Column(
          children: [
            _chips(),
            _shipments(),
            Obx(() => _more()),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: shipmentsForUserController.onShipmentCreateTap,
          mini: true,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text('Shipments',
          style: Theme.of(context).appBarTheme.titleTextStyle),
      actions: [
        if (1 == 2)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                    if (shipmentsForUserController.chipStatus.value ==
                        ShipmentStatus.finding) {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.finding;
                    }
                    shipmentsForUserController.resetShipments();
                    shipmentsForUserController
                        .fetchShipmentsByConditionByFirstAfter();
                  },
                  child: shipmentsForUserController.chipStatus.value ==
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
                    if (shipmentsForUserController.chipStatus.value ==
                        ShipmentStatus.delivering) {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.delivering;
                    }
                    shipmentsForUserController.resetShipments();
                    shipmentsForUserController
                        .fetchShipmentsByConditionByFirstAfter();
                  },
                  child: shipmentsForUserController.chipStatus.value ==
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
                    if (shipmentsForUserController.chipStatus.value ==
                        ShipmentStatus.delivered) {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.delivered;
                    }
                    shipmentsForUserController.resetShipments();
                    shipmentsForUserController
                        .fetchShipmentsByConditionByFirstAfter();
                  },
                  child: shipmentsForUserController.chipStatus.value ==
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
                    if (shipmentsForUserController.chipStatus.value ==
                        ShipmentStatus.canceled) {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.undefined;
                    } else {
                      shipmentsForUserController.chipStatus.value =
                          ShipmentStatus.canceled;
                    }
                    shipmentsForUserController.resetShipments();
                    shipmentsForUserController
                        .fetchShipmentsByConditionByFirstAfter();
                  },
                  child: shipmentsForUserController.chipStatus.value ==
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
            return shipmentsForUserController.shipmentItems[index];
          },
          itemCount: shipmentsForUserController.shipmentItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      shipmentsForUserController.shipmentItems.length !=
              shipmentsForUserController.shipmentsTotalCount.value
          ? TextButton(
              onPressed: () {
                shipmentsForUserController
                    .fetchShipmentsByConditionByFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${shipmentsForUserController.shipmentItems.length}/${shipmentsForUserController.shipmentsTotalCount.value}'),
    ]);
  }
}
