class ShipmentAttachment {
  late int id;
  late int shipmentId;
  late String fileUrl;
  late String thumbUrl;
  late String type;

  ShipmentAttachment({
    this.id = 0,
    this.shipmentId = 0,
    this.fileUrl = '',
    this.thumbUrl = '',
    this.type = '',
  });

  factory ShipmentAttachment.fromJson(Map<String, dynamic> json) =>
      ShipmentAttachment(
        id: json['id'] ?? 0,
        shipmentId: json['shipmentId'] ?? 0,
        fileUrl: json['fileUrl'] ?? '',
        thumbUrl: json['thumbUrl'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ShipmentAttachment',
        'id': id,
        'shipmentId': shipmentId,
        'fileUrl': fileUrl,
        'thumbUrl': thumbUrl,
        'type': type,
      };

  @override
  String toString() => toJson().toString();
}

class ShipmentAttachments {
  late List<ShipmentAttachment> nodes;
  late int totalCount;

  ShipmentAttachments({
    this.nodes = const [],
    this.totalCount = 0,
  });

  factory ShipmentAttachments.fromJson(Map<String, dynamic> json) =>
      ShipmentAttachments(
        nodes: convertMapsToShipmentAttachments(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ShipmentAttachmentsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertShipmentAttachmentToMap(
    ShipmentAttachment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ShipmentAttachment? convertMapToShipmentAttachment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ShipmentAttachment.fromJson(json);
}

List<Map<String, dynamic>> convertShipmentAttachmentsToMaps(
    List<ShipmentAttachment>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ShipmentAttachment> convertMapsToShipmentAttachments(
    List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ShipmentAttachment.fromJson(e)).toList();
}

// ShipmentAttachments
Map<String, dynamic>? convertShipmentAttachmentsToMap(
    ShipmentAttachments? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ShipmentAttachments? convertMapToShipmentAttachments(
    Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ShipmentAttachments.fromJson(json);
}
