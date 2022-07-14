class MessageAttachment {
  late int id;
  late int messageId;
  late String fileUrl;
  late String thumbUrl;
  late String type;

  MessageAttachment({
    this.id = 0,
    this.messageId = 0,
    this.fileUrl = '',
    this.thumbUrl = '',
    this.type = '',
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) =>
      MessageAttachment(
        id: json['id'] ?? 0,
        messageId: json['messageId'] ?? 0,
        fileUrl: json['fileUrl'] ?? '',
        thumbUrl: json['thumbUrl'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'MessageAttachment',
        'id': id,
        'messageId': messageId,
        'fileUrl': fileUrl,
        'thumbUrl': thumbUrl,
        'type': type,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertMessageAttachmentToMap(MessageAttachment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

MessageAttachment? convertMapToMessageAttachment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return MessageAttachment.fromJson(json);
}

List<Map<String, dynamic>> convertMessageAttachmentsToMaps(
    List<MessageAttachment>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<MessageAttachment> convertMapsToMessageAttachments(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => MessageAttachment.fromJson(e)).toList();
}

// MessageAttachments
class MessageAttachments {
  late List<MessageAttachment> nodes;
  late int totalCount;

  MessageAttachments({
    this.nodes = const [],
    this.totalCount = 0,
  });

  factory MessageAttachments.fromJson(Map<String, dynamic> json) =>
      MessageAttachments(
        nodes: convertMapsToMessageAttachments(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'MessageAttachmentsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertMessageAttachmentsToMap(
    MessageAttachments? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

MessageAttachments? convertMapToMessageAttachments(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return MessageAttachments.fromJson(json);
}
