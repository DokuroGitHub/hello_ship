class ConversationInvitee {
  late int id;
  late String conversationId;
  late String userid;
  late String createdBy;
  late DateTime? createdAt;
  late String role;
  late DateTime? acceptedAt;
  late DateTime? rejectedAt;

  ConversationInvitee({
    this.id = 0,
    this.conversationId = '',
    this.userid = '',
    this.createdBy = '',
    this.createdAt,
    this.role = '',
    this.acceptedAt,
    this.rejectedAt,
  });

  factory ConversationInvitee.fromJson(Map<String, dynamic> json) =>
      ConversationInvitee(
        id: json['id'] ?? 0,
        conversationId: json['conversationId'] ?? '',
        userid: json['userid'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt']??''),
        role: json['role'] ?? '',
        acceptedAt: DateTime.tryParse(json['acceptedAt']??''),
        rejectedAt: DateTime.tryParse(json['rejectedAt']??''),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ConversationInvitee',
        'id': id,
        'conversationId': conversationId,
        'userid': userid,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'role': role,
        'acceptedAt': acceptedAt,
        'rejectedAt': rejectedAt,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertConversationInviteeToMap(ConversationInvitee? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ConversationInvitee? convertMapToConversationInvitee(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ConversationInvitee.fromJson(json);
}

List<Map<String, dynamic>> convertConversationInviteesToMaps(
    List<ConversationInvitee>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ConversationInvitee> convertMapsToConversationInvitees(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ConversationInvitee.fromJson(e)).toList();
}