import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard/shipments/shipment_item_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/screens/dashboard/shipments/shipment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShipmentItem extends StatelessWidget {
  final Shipment initialShipment;
  final Function(Shipment shipment)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  const ShipmentItem(
    this.initialShipment, {
    Key? initialKey,
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  }) : super(key: initialKey);

  @override
  Widget build(BuildContext context) {
    debugPrint('ShipmentItem');
    final shipmentItemController = ShipmentItemController(
      initialShipment,
      onUpdateCallBack: onUpdateCallBack,
      onDeleteCallBack: onDeleteCallBack,
      onRefetchCallBack: onRefetchCallBack,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      shipmentItemController.initPlz();
    });

    return GestureDetector(
      onTap: () {
        Get.to(() => ShipmentScreen(
              shipmentItemController.initialShipment,
              onDeleteCallback: onDeleteCallBack,
            ));
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => shipmentItemController.status.value == Status.ready
              ? Row(
                  children: [
                    Expanded(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(mainAxisSize: MainAxisSize.min, children: [
                              const Icon(Icons.texture),
                              Text(
                                  'Id: ${shipmentItemController.initialShipment.id}'),
                            ]),
                            Text(
                              stringHelper.dateTimeToDurationString(
                                  shipmentItemController
                                          .initialShipment.editedAt ??
                                      shipmentItemController
                                          .initialShipment.createdAt),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const Text('Type: '),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.blue),
                                child: Text(shipmentItemController
                                    .initialShipment.type),
                              ),
                            ]),
                            Row(children: [
                              const Text('Price: '),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.green),
                                child: Text(
                                    '${shipmentItemController.initialShipment.cod} vnđ'),
                              ),
                            ]),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const Text('Service: '),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.red.withOpacity(0.8)),
                                child: Text(shipmentItemController
                                    .initialShipment.service),
                              ),
                            ]),
                            Row(children: [
                              const Text('Status: '),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: Colors.green),
                                child: Text(shipmentItemController
                                    .initialShipment.status),
                              ),
                            ]),
                          ],
                        ),
                      ]),
                    ),
                    _actions(shipmentItemController),
                  ],
                )
              : const CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _actions(ShipmentItemController shipmentItemController) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
      ),
      onSelected: (selected) {
        if (selected == 'view') {
          shipmentItemController.onShipmentViewTap();
        }
        if (selected == 'shipment_screen') {
          Get.to(() => ShipmentScreen(
                shipmentItemController.initialShipment,
                onDeleteCallback: onDeleteCallBack,
              ));
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'view',
            child: Text('View'),
          ),
          const PopupMenuItem<String>(
            value: 'shipment_screen',
            child: Text('Go to shipment screen'),
          ),
        ];
      },
    );
  }
}
