class DeletedConversation {
  late int id;
  late String conversationId;
  late String userId;
  late String createdBy;
  late DateTime? createdAt;

  DeletedConversation({
    this.id = 0,
    this.conversationId = '',
    this.userId = '',
    this.createdBy = '',
    this.createdAt,
  });

  factory DeletedConversation.fromJson(Map<String, dynamic> json) =>
      DeletedConversation(
        id: json['id'] ?? 0,
        conversationId: json['conversationId'] ?? '',
        userId: json['userId'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'DeletedConversation',
        'id': id,
        'conversationId': conversationId,
        'userId': userId,
        'createdBy': createdBy,
        'createdAt': createdAt,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertDeletedConversationToMap(
    DeletedConversation? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

DeletedConversation? convertMapToDeletedConversation(
    Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return DeletedConversation.fromJson(json);
}

List<Map<String, dynamic>> convertDeletedConversationsToMaps(
    List<DeletedConversation>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<DeletedConversation> convertMapsToDeletedConversations(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => DeletedConversation.fromJson(e)).toList();
}