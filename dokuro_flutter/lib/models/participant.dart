import 'package:dokuro_flutter/models/user.dart';

class Participant {
  late int id;
  late String conversationId;
  late String userId;
  late String nickname;
  late String createdBy;
  late DateTime? createdAt;
  late String grantedBy;
  late DateTime? grantedAt;
  late String role;
  //
  late User? user;

  Participant({
    this.id = 0,
    this.conversationId = '',
    this.userId = '',
    this.nickname = '',
    this.createdBy = '',
    this.createdAt,
    this.grantedBy = '',
    this.grantedAt,
    this.role = '',
    this.user,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json['id'] ?? 0,
        conversationId: json['conversationId'] ?? '',
        userId: json['userId'] ?? '',
        nickname: json['nickname'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        grantedBy: json['grantedBy'] ?? '',
        grantedAt: DateTime.tryParse(json['grantedAt'] ?? ''),
        role: json['role'] ?? '',
        user: convertMapToUser(json['user']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'Participant',
        'id': id,
        'conversationId': conversationId,
        'userId': userId,
        'nickname': nickname,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'grantedBy': grantedBy,
        'grantedAt': grantedAt,
        'role': role,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertParticipantToMap(Participant? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Participant? convertMapToParticipant(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Participant.fromJson(json);
}

List<Map<String, dynamic>> convertParticipantsToMaps(
    List<Participant>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<Participant> convertMapsToParticipants(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => Participant.fromJson(e)).toList();
}

// Participants
class Participants {
  late List<Participant> nodes;
  late int totalCount;

  Participants({
    this.nodes = const [],
    this.totalCount = 0,
  });

  factory Participants.fromJson(Map<String, dynamic> json) => Participants(
        nodes: convertMapsToParticipants(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ParticipantsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertParticipantsToMap(Participants? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Participants? convertMapToParticipants(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Participants.fromJson(json);
}
