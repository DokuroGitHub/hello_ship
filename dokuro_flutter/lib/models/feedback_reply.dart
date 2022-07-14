class FeedbackReply {
  late int id;
  late int feedbackId;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late DateTime? deletedAt;
  late String text;
  late int replyTo;

  FeedbackReply({
    this.id = 0,
    this.feedbackId = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.text = '',
    this.replyTo = 0,
  });

  factory FeedbackReply.fromJson(Map<String, dynamic> json) => FeedbackReply(
        id: json['id'] ?? 0,
        feedbackId: json['feedbackId'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt']??''),
        editedAt: DateTime.tryParse(json['editedAt']??''),
        deletedAt: DateTime.tryParse(json['deletedAt']??''),
        text: json['text'] ?? '',
        replyTo: json['replyTo'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'FeedbackReply',
        'id': id,
        'feedbackId': feedbackId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'deletedAt': deletedAt,
        'text': text,
        'replyTo': replyTo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertFeedbackReplyToMap(FeedbackReply? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

FeedbackReply? convertMapToFeedbackReply(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return FeedbackReply.fromJson(json);
}

List<Map<String, dynamic>> convertFeedbackRepliesToMaps(
    List<FeedbackReply>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<FeedbackReply> convertMapsToFeedbackReplies(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => FeedbackReply.fromJson(e)).toList();
}