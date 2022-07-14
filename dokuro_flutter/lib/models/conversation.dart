import 'package:dokuro_flutter/models/message.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/participant.dart';
import 'package:dokuro_flutter/models/user.dart';

class Conversation {
  late String id;
  late String createdBy;
  late DateTime? createdAt;
  late String editedBy;
  late DateTime? editedAt;
  late String deletedBy;
  late DateTime? deletedAt;
  late String title;
  late String description;
  late String photoUrl;
  late int? lastMessageId;
  //
  late Message? lastMessage;
  late User? userByCreatedBy;
  late Participants? participants;
  late Messages? messages;

  Conversation({
    this.id = '',
    this.createdBy = '',
    this.createdAt,
    this.editedBy = '',
    this.editedAt,
    this.deletedBy = '',
    this.deletedAt,
    this.title = '',
    this.description = '',
    this.photoUrl = '',
    this.lastMessageId = 0,
    this.lastMessage,
    this.userByCreatedBy,
    this.participants,
    this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedBy: json['editedBy'] ?? '',
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        deletedBy: json['deletedBy'] ?? '',
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        photoUrl: json['photoUrl'] ?? '',
        lastMessageId: json['photoUrl'] ?? 0,
        lastMessage: convertMapToMessage(json['lastMessage']),
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
        participants: convertMapToParticipants(json['participants']),
        messages: convertMapToMessages(json['messages']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'Conversation',
        'id': id,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedBy': editedBy,
        'editedAt': editedAt,
        'deletedBy': deletedBy,
        'deletedAt': deletedAt,
        'title': title,
        'description': description,
        'photoUrl': photoUrl,
        'lastMessageId': lastMessageId,
        'lastMessage': lastMessage,
        'userByCreatedBy': userByCreatedBy,
        'participants': participants,
        'messages': messages,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertConversationToMap(Conversation? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Conversation? convertMapToConversation(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Conversation.fromJson(json);
}

List<Map<String, dynamic>> convertConversationsToMaps(
    List<Conversation>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<Conversation> convertMapsToConversations(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => Conversation.fromJson(e)).toList();
}

// Conversations
class Conversations {
  late List<Conversation> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  Conversations({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory Conversations.fromJson(Map<String, dynamic> json) => Conversations(
        nodes: convertMapsToConversations(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ConversationsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertConversationsToMap(Conversations? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Conversations? convertMapToConversations(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Conversations.fromJson(json);
}
