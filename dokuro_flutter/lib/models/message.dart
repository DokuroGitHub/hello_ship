import 'package:dokuro_flutter/models/message_attachment.dart';
import 'package:dokuro_flutter/models/user.dart';

class Message {
  late int id;
  late String conversationId;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? deletedAt;
  late String deletedBy;
  late String text;
  late int replyTo;
  //
  late User? userByCreatedBy;
  late MessageAttachments? messageAttachments;

  Message({
    this.id = 0,
    this.conversationId = '',
    this.createdBy = '',
    this.createdAt,
    this.deletedAt,
    this.text = '',
    this.replyTo = 0,
    this.userByCreatedBy,
    this.messageAttachments,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] ?? 0,
        conversationId: json['conversationId'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        text: json['text'] ?? '',
        replyTo: json['replyTo'] ?? 0,
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
        messageAttachments:
            convertMapToMessageAttachments(json['messageAttachments']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'Message',
        'id': id,
        'conversationId': conversationId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'deletedAt': deletedAt,
        'text': text,
        'replyTo': replyTo,
        'userByCreatedBy': userByCreatedBy,
        'messageAttachments': messageAttachments,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertMessageToMap(Message? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Message? convertMapToMessage(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Message.fromJson(json);
}

List<Map<String, dynamic>> convertMessagesToMaps(List<Message>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<Message> convertMapsToMessages(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => Message.fromJson(e)).toList();
}

// Messages
class Messages {
  late List<Message> nodes;
  late int totalCount;

  Messages({
    this.nodes = const [],
    this.totalCount = 0,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        nodes: convertMapsToMessages(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'MessagesConnection',
        'nodes': nodes,
        'totalCount': totalCount,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertMessagesToMap(Messages? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Messages? convertMapToMessages(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Messages.fromJson(json);
}
