class FeedbackAttachment {
  late int id;
  late int feedbackId;
  late String fileUrl;
  late String thumbUrl;
  late String type;

  FeedbackAttachment({
    this.id = 0,
    this.feedbackId = 0,
    this.fileUrl = '',
    this.thumbUrl = '',
    this.type = '',
  });

  factory FeedbackAttachment.fromJson(Map<String, dynamic> json) =>
      FeedbackAttachment(
        id: json['id'] ?? 0,
        feedbackId: json['feedbackId'] ?? 0,
        fileUrl: json['fileUrl'] ?? '',
        thumbUrl: json['thumbUrl'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'FeedbackAttachment',
        'id': id,
        'feedbackId': feedbackId,
        'fileUrl': fileUrl,
        'thumbUrl': thumbUrl,
        'type': type,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertFeedbackAttachmentToMap(FeedbackAttachment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

FeedbackAttachment? convertMapToFeedbackAttachment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return FeedbackAttachment.fromJson(json);
}

List<Map<String, dynamic>> convertFeedbackAttachmentsToMaps(
    List<FeedbackAttachment>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<FeedbackAttachment> convertMapsToFeedbackAttachments(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => FeedbackAttachment.fromJson(e)).toList();
}