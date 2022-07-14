import 'dart:math';

class ShipmentAddressTo {
  late int shipmentId;
  late String details;
  late String street;
  late String district;
  late String city;
  late Point? location;

  ShipmentAddressTo({
    this.shipmentId = 0,
    this.details = '',
    this.street = '',
    this.district = '',
    this.city = '',
    this.location,
  });

  factory ShipmentAddressTo.fromJson(Map<String, dynamic> json) =>
      ShipmentAddressTo(
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
        '__typename': 'ShipmentAddressTo',
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

Map<String, dynamic>? convertShipmentAddressToToMap(ShipmentAddressTo? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ShipmentAddressTo? convertMapToShipmentAddressTo(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ShipmentAddressTo.fromJson(json);
}

List<Map<String, dynamic>> convertShipmentAddressTosToMaps(
    List<ShipmentAddressTo>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ShipmentAddressTo> convertMapsToShipmentAddressTos(
    List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ShipmentAddressTo.fromJson(e)).toList();
}
