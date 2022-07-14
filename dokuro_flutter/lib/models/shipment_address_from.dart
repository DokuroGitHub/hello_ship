import 'dart:math';

class ShipmentAddressFrom {
  late int shipmentId;
  late String details;
  late String street;
  late String district;
  late String city;
  late Point? location;

  ShipmentAddressFrom({
    this.shipmentId = 0,
    this.details = '',
    this.street = '',
    this.district = '',
    this.city = '',
    this.location,
  });

  factory ShipmentAddressFrom.fromJson(Map<String, dynamic> json) =>
      ShipmentAddressFrom(
        shipmentId: json['shipmentId'] ?? 0,
        details: json['details'] ?? '',
        street: json['street'] ?? '',
        district: json['district'] ?? '',
        city: json['city'] ?? '',
        location:
            json['location']?['x'] != null && json['location']?['y'] != null
                ? Point(json['location']['x'], json['location']['y'])
                : null,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ShipmentAddressFrom',
        'shipmentId': shipmentId,
        'details': details,
        'street': street,
        'district': district,
        'city': city,
        'location': location,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertShipmentAddressFromToMap(
    ShipmentAddressFrom? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ShipmentAddressFrom? convertMapToShipmentAddressFrom(
    Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ShipmentAddressFrom.fromJson(json);
}

List<Map<String, dynamic>> convertShipmentAddressFromsToMaps(
    List<ShipmentAddressFrom>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ShipmentAddressFrom> convertMapsToShipmentAddressFroms(
    List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ShipmentAddressFrom.fromJson(e)).toList();
}
