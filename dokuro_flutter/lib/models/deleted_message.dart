class DeletedMessage {
  late int id;
  late int messageId;
  late String createdBy;
  late DateTime? createdAt;

  DeletedMessage({
    this.id = 0,
    this.messageId = 0,
    this.createdBy = '',
    this.createdAt,
  });

  factory DeletedMessage.fromJson(Map<String, dynamic> json) => DeletedMessage(
        id: json['id'] ?? 0,
        messageId: json['messageId'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt']??''),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'DeletedMessage',
        'id': id,
        'messageId': messageId,
        'createdBy': createdBy,
        'createdAt': createdAt,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertDeletedMessageToMap(DeletedMessage? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

DeletedMessage? convertMapToDeletedMessage(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return DeletedMessage.fromJson(json);
}

List<Map<String, dynamic>> convertDeletedMessagesToMaps(
    List<DeletedMessage>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<DeletedMessage> convertMapsToDeletedMessages(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => DeletedMessage.fromJson(e)).toList();
}