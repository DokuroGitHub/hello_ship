class MessageEmote {
  late int id;
  late int messageId;
  late String createdBy;
  late DateTime? createdAt;
  late String code;

  MessageEmote({
    this.id = 0,
    this.messageId = 0,
    this.createdBy = '',
    this.createdAt,
    this.code = '',
  });

  factory MessageEmote.fromJson(Map<String, dynamic> json) => MessageEmote(
        id: json['id'] ?? 0,
        messageId: json['uid'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt']??''),
        code: json['code'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typecreatedBy': 'MessageEmote',
        'id': id,
        'messageId': messageId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'code': code,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertMessageEmoteToMap(MessageEmote? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

MessageEmote? convertMapToMessageEmote(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return MessageEmote.fromJson(json);
}

List<Map<String, dynamic>> convertMessageEmotesToMaps(
    List<MessageEmote>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<MessageEmote> convertMapsToMessageEmotes(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => MessageEmote.fromJson(e)).toList();
}