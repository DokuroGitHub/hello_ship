class ReplyAttachment {
  late int id;
  late int replyId;
  late String fileUrl;
  late String thumbUrl;
  late String type;

  ReplyAttachment({
    this.id = 0,
    this.replyId = 0,
    this.fileUrl = '',
    this.thumbUrl = '',
    this.type = '',
  });

  factory ReplyAttachment.fromJson(Map<String, dynamic> json) =>
      ReplyAttachment(
        id: json['id'] ?? 0,
        replyId: json['replyId'] ?? 0,
        fileUrl: json['fileUrl'] ?? '',
        thumbUrl: json['thumbUrl'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ReplyAttachment',
        "id": id,
        'replyId': replyId,
        'fileUrl': fileUrl,
        'thumbUrl': thumbUrl,
        'type': type,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertReplyAttachmentToMap(ReplyAttachment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ReplyAttachment? convertMapToReplyAttachment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ReplyAttachment.fromJson(json);
}

List<Map<String, dynamic>> convertReplyAttachmentsToMaps(
    List<ReplyAttachment>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ReplyAttachment> convertMapsToReplyAttachments(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ReplyAttachment.fromJson(e)).toList();
}