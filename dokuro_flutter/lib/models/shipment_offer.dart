import 'package:dokuro_flutter/models/page_info.dart';

import 'user.dart';

enum ShipmentOffersOrderBy {
  //idAsc,
  //idDesc,
  oldest,
  newest,
  priceDesc,
  priceAsc,
  //createdByMe,
}

class ShipmentOffer {
  late int id;
  late int shipmentId;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late DateTime? deletedAt;
  late String notes;
  late int price;
  late DateTime? acceptedAt;
  late DateTime? rejectedAt;
  //
  late User? userByCreatedBy;

  ShipmentOffer({
    this.id = 0,
    this.shipmentId = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.notes = '',
    this.price = 0,
    this.acceptedAt,
    this.rejectedAt,
    this.userByCreatedBy,
  });

  factory ShipmentOffer.fromJson(Map<String, dynamic> json) => ShipmentOffer(
        id: json['id'] ?? 0,
        shipmentId: json['shipmentId'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        notes: json['notes'] ?? '',
        price: json['price'] ?? 0,
        acceptedAt: DateTime.tryParse(json['acceptedAt'] ?? ''),
        rejectedAt: DateTime.tryParse(json['rejectedAt'] ?? ''),
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ShipmentOffer',
        'id': id,
        'shipmentId': shipmentId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'deletedAt': deletedAt,
        'notes': notes,
        'price': price,
        'acceptedAt': acceptedAt,
        'rejectedAt': rejectedAt,
        'userByCreatedBy': userByCreatedBy,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertShipmentOfferToMap(ShipmentOffer? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ShipmentOffer? convertMapToShipmentOffer(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ShipmentOffer.fromJson(json);
}

List<Map<String, dynamic>> convertShipmentOffersToMaps(
    List<ShipmentOffer>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ShipmentOffer> convertMapsToShipmentOffers(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ShipmentOffer.fromJson(e)).toList();
}

// ShipmentOffers
class ShipmentOffers {
  late List<ShipmentOffer> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  ShipmentOffers({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory ShipmentOffers.fromJson(Map<String, dynamic> json) => ShipmentOffers(
        nodes: convertMapsToShipmentOffers(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ShipmentOffersConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertShipmentOffersToMap(ShipmentOffers? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ShipmentOffers? convertMapToShipmentOffers(Map<String, dynamic>? map) {
  if (map == null) {
    return null;
  }
  return ShipmentOffers.fromJson(map);
}
