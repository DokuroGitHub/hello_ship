import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/shipment_address_from.dart';
import 'package:dokuro_flutter/models/shipment_address_to.dart';
import 'package:dokuro_flutter/models/shipment_attachment.dart';
import 'package:dokuro_flutter/models/shipment_offer.dart';
import 'package:dokuro_flutter/models/shipment_parcel.dart';
import 'package:dokuro_flutter/models/user.dart';

class Shipment {
  late int id;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late DateTime? deletedAt;
  late int cod;
  late String phone;
  late String notes;
  late String type;
  late String service;
  late String status;
  late int acceptedOfferId;
  //
  late ShipmentAddressFrom? shipmentAddressFrom;
  late ShipmentAddressTo? shipmentAddressTo;
  late ShipmentParcel? shipmentParcel;
  late ShipmentAttachments? shipmentAttachments;
  late ShipmentOffers? shipmentOffers;
  late User? userByCreatedBy;
  late ShipmentOffer? acceptedOffer;

  Shipment({
    this.id = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.cod = 0,
    this.phone = '',
    this.notes = '',
    this.type = '',
    this.service = '',
    this.status = '',
    this.acceptedOfferId = 0,
    this.shipmentAddressFrom,
    this.shipmentAddressTo,
    this.shipmentParcel,
    this.shipmentAttachments,
    this.shipmentOffers,
    this.userByCreatedBy,
    this.acceptedOffer,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        id: json['id'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        cod: json['cod'] ?? 0,
        phone: json['phone'] ?? '',
        notes: json['notes'] ?? '',
        type: json['type'] ?? '',
        service: json['service'] ?? '',
        status: json['status'] ?? '',
        acceptedOfferId: json['acceptedOfferId'] ?? 0,
        shipmentAddressFrom:
            convertMapToShipmentAddressFrom(json['shipmentAddressFrom']),
        shipmentAddressTo:
            convertMapToShipmentAddressTo(json['shipmentAddressTo']),
        shipmentParcel: convertMapToShipmentParcel(json['shipmentParcel']),
        shipmentAttachments:
            convertMapToShipmentAttachments(json['shipmentAttachments']),
        shipmentOffers: convertMapToShipmentOffers(json['shipmentOffers']),
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
        acceptedOffer: convertMapToShipmentOffer(json['acceptedOffer']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'Shipment',
        'id': id,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'deletedAt': deletedAt,
        'cod': cod,
        'phone': phone,
        'notes': notes,
        'type': type,
        'service': service,
        'status': status,
        'acceptedOfferId': acceptedOfferId,
        'shipmentAddressFrom': shipmentAddressFrom,
        'shipmentAddressTo': shipmentAddressTo,
        'shipmentParcel': shipmentParcel,
        'shipmentAttachments': shipmentAttachments,
        'shipmentOffers': shipmentOffers,
        'userByCreatedBy': userByCreatedBy,
        'acceptedOffer': acceptedOffer,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertShipmentToMap(Shipment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Shipment? convertMapToShipment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Shipment.fromJson(json);
}

List<Map<String, dynamic>> convertShipmentsToMaps(List<Shipment>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<Shipment> convertMapsToShipments(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => Shipment.fromJson(e)).toList();
}

// Shipments
class Shipments {
  late List<Shipment> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  Shipments({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory Shipments.fromJson(Map<String, dynamic> json) => Shipments(
        nodes: convertMapsToShipments(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ShipmentsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertShipmentsToMap(Shipments? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Shipments? convertMapToShipments(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Shipments.fromJson(json);
}
