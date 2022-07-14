import 'package:dokuro_flutter/controllers/dashboard/shipment_offers/shipment_offers_for_shipper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShipmentOffersForShipperScreen extends StatefulWidget {
  const ShipmentOffersForShipperScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentOffersForShipperScreen> createState() =>
      _ShipmentOffersForShipperScreenState();
}

class _ShipmentOffersForShipperScreenState
    extends State<ShipmentOffersForShipperScreen> {
  final shipmentOffersForShipperController =
      ShipmentOffersForShipperController();

  @override
  void initState() {
    shipmentOffersForShipperController.initPlz();
    super.initState();
  }

  @override
  dispose() {
    shipmentOffersForShipperController.disposePlz();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('${widget.runtimeType} build');
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        controller: shipmentOffersForShipperController.scrollController,
        child: Column(
          children: [
            const SizedBox(height: 40),
            _shipmentOffers(),
            Obx(() => _more()),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text('Shipment Offers',
          style: Theme.of(context).appBarTheme.titleTextStyle),
      actions: [if (1 == 2)
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          color: Theme.of(context).appBarTheme.titleTextStyle?.color,
        ),
      ],
    );
  }

  Widget _shipmentOffers() {
    debugPrint('_shipmentOffers');
    return Obx(() => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return shipmentOffersForShipperController.offerItems[index];
          },
          itemCount: shipmentOffersForShipperController.offerItems.length,
        ));
  }

  Widget _more() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      shipmentOffersForShipperController.offerItems.length !=
              shipmentOffersForShipperController.offersTotalCount.value
          ? TextButton(
              onPressed: () {
                shipmentOffersForShipperController
                    .fetchShipmentsByShipmentOffersByCurrentUserIdFirstAfter();
              },
              child: const Text('Xem thêm'),
            )
          : const SizedBox(),
      Text(
          '${shipmentOffersForShipperController.offerItems.length}/${shipmentOffersForShipperController.offersTotalCount.value}'),
    ]);
  }
}
