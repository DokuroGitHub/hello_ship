class ShipmentParcel {
  late int shipmentId;
  late String code;
  late double width;
  late double length;
  late double height;
  late double weight;
  late String nameFrom;
  late String nameTo;
  late String phoneFrom;
  late String phoneTo;
  late String description;

  ShipmentParcel({
    this.shipmentId = 0,
    this.code = '',
    this.width = 0.0,
    this.length = 0.0,
    this.height = 0.0,
    this.weight = 0.0,
    this.nameFrom = '',
    this.nameTo = '',
    this.phoneFrom = '',
    this.phoneTo = '',
    this.description = '',
  });

  factory ShipmentParcel.fromJson(Map<String, dynamic> json) => ShipmentParcel(
        shipmentId: json['id'] ?? 0,
        code: json['code'] ?? '',
        width: json['width'] ?? 0.0,
        length: json['length'] ?? 0.0,
        height: json['height'] ?? 0.0,
        weight: json['weight'] ?? 0.0,
        nameFrom: json['nameFrom'] ?? '',
        nameTo: json['nameTo'] ?? '',
        phoneFrom: json['phoneFrom'] ?? '',
        phoneTo: json['phoneTo'] ?? '',
        description: json['description'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ShipmentParcel',
        'shipmentId': shipmentId,
        'code': code,
        'width': width,
        'length': length,
        'height': height,
        'weight': weight,
        'nameFrom': nameFrom,
        'nameTo': nameTo,
        'phoneFrom': phoneFrom,
        'phoneTo': phoneTo,
        'description': description,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertShipmentParcelToMap(ShipmentParcel? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ShipmentParcel? convertMapToShipmentParcel(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ShipmentParcel.fromJson(json);
}

List<Map<String, dynamic>> convertShipmentParcelsToMaps(
    List<ShipmentParcel>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ShipmentParcel> convertMapsToShipmentParcels(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ShipmentParcel.fromJson(e)).toList();
}