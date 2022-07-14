import 'package:dokuro_flutter/constants/status.dart';
import 'package:dokuro_flutter/controllers/dashboard/shipments/shipment_offer_item_controller.dart';
import 'package:dokuro_flutter/helpers/string_helper.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/screens/dashboard/_components/user/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShipmentOfferItem extends StatelessWidget {
  final ShipmentOffer initialShipmentOffer;
  final Shipment? initialShipment;
  final Function(ShipmentOffer shipmentOffer)? onUpdateCallBack;
  final Function? onDeleteCallBack;
  final Function? onRefetchCallBack;
  const ShipmentOfferItem(
    this.initialShipmentOffer, {
    Key? initialKey,
    this.initialShipment,
    this.onUpdateCallBack,
    this.onDeleteCallBack,
    this.onRefetchCallBack,
  }) : super(key: initialKey);

  @override
  Widget build(BuildContext context) {
    //debugPrint('ShipmentOfferItem, id: ${initialShipmentOffer.id}');

    final shipmentOfferItemController = ShipmentOfferItemController(
      initialShipmentOffer,
      intialShipment: initialShipment,
      onUpdateCallBack: onUpdateCallBack,
      onDeleteCallBack: onDeleteCallBack,
      onRefetchCallBack: onRefetchCallBack,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      shipmentOfferItemController.initPlz();
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).focusColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Obx(() => shipmentOfferItemController.status.value == Status.ready
                ? Row(
                    children: [
                      _userAvatar(shipmentOfferItemController),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Stack(children: [
                          // (price + time)/notes
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child:
                                          _price(shipmentOfferItemController)),
                                  Flexible(
                                      child:
                                          _date(shipmentOfferItemController)),
                                ],
                              ),
                              _notes(shipmentOfferItemController),
                            ],
                          ),
                          // accepted / rejected
                          _accOrRej(shipmentOfferItemController),
                        ]),
                      ),
                      _actions(shipmentOfferItemController),
                    ],
                  )
                : const CircularProgressIndicator()),
      ),
    );
  }

  Widget _userAvatar(ShipmentOfferItemController shipmentOfferItemController) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      child: UserAvatar(
        avatarUrl: shipmentOfferItemController
            .initialShipmentOffer.userByCreatedBy?.avatarUrl,
        lastSeen: shipmentOfferItemController
            .initialShipmentOffer.userByCreatedBy?.lastSeen,
      ),
    );
  }

  Widget _price(ShipmentOfferItemController shipmentOfferItemController) {
    return Text(
        'Price: ${shipmentOfferItemController.initialShipmentOffer.price} vnđ');
  }

  Widget _date(ShipmentOfferItemController shipmentOfferItemController) {
    return Text(stringHelper.dateTimeToDurationString(
        shipmentOfferItemController.initialShipmentOffer.editedAt ??
            shipmentOfferItemController.initialShipmentOffer.createdAt));
  }

  Widget _notes(ShipmentOfferItemController shipmentOfferItemController) {
    return Text(
      '${AppLocalizations.of(Get.context!).notesCap}: ${shipmentOfferItemController.initialShipmentOffer.notes}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _actions(ShipmentOfferItemController shipmentOfferItemController) {
    return PopupMenuButton<String>(
      tooltip: 'Actions',
      icon: Icon(
        Icons.more_horiz,
        color: Theme.of(Get.context!).appBarTheme.titleTextStyle?.color,
      ),
      onSelected: (selected) {
        if (selected == 'view') {
          shipmentOfferItemController.onViewTap();
        }
        if (selected == 'edit') {
          shipmentOfferItemController.onEditTap();
        }
        if (selected == 'delete') {
          shipmentOfferItemController.onDeleteTap();
        }
        if (selected == 'accept') {
          shipmentOfferItemController.onAcceptTap();
        }
        if (selected == 'reject') {
          shipmentOfferItemController.onRejectTap();
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'view',
            child: Text('View'),
          ),
          if (shipmentOfferItemController.initialShipmentOffer.createdBy ==
              shipmentOfferItemController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
          if (shipmentOfferItemController.initialShipmentOffer.createdBy ==
              shipmentOfferItemController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          if (shipmentOfferItemController.intialShipment?.createdBy ==
              shipmentOfferItemController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'accept',
              child: Text('Accept'),
            ),
          if (shipmentOfferItemController.intialShipment?.createdBy ==
              shipmentOfferItemController.currentUser.id)
            const PopupMenuItem<String>(
              value: 'reject',
              child: Text('Reject'),
            ),
        ];
      },
    );
  }

  Widget _accOrRej(ShipmentOfferItemController shipmentOfferItemController) {
    return shipmentOfferItemController.initialShipmentOffer.acceptedAt != null
        ? Positioned(
            bottom: 0,
            right: 0,
            child: Tooltip(
              message:
                  'Accepted at ${stringHelper.dateTimeToStringV4(shipmentOfferItemController.initialShipmentOffer.acceptedAt)}',
              child: const Text(
                'Accepted',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 0.5,
                    ),
                  ],
                ),
              ),
            ),
          )
        : shipmentOfferItemController.initialShipmentOffer.rejectedAt != null
            ? Positioned(
                bottom: 0,
                right: 0,
                child: Tooltip(
                  message:
                      'Rejected at ${stringHelper.dateTimeToStringV4(shipmentOfferItemController.initialShipmentOffer.rejectedAt)}',
                  child: const Text(
                    'Rejected',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox();
  }
}
