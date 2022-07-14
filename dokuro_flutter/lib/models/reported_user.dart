import 'package:dokuro_flutter/models/conversation.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/post.dart';
import 'package:dokuro_flutter/models/user.dart';

class ReportedUser {
  late int id;
  late String userId;
  late String createdBy;
  late DateTime? createdAt;
  late String text;
  late int postId;
  late String conversationId;
  late String type;
  late String status;
  //
  late User? user;
  late User? userByCreatedBy;
  late Post? post;
  late Conversation? conversation;

  ReportedUser({
    this.id = 0,
    this.userId = '',
    this.createdBy = '',
    this.createdAt,
    this.text = '',
    this.postId = 0,
    this.conversationId = '',
    this.type = '',
    this.status = '',
    //
    this.user,
    this.userByCreatedBy,
    this.post,
    this.conversation,
  });

  factory ReportedUser.fromJson(Map<String, dynamic> json) => ReportedUser(
        id: json['id'] ?? 0,
        userId: json['userId'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        text: json['text'] ?? '',
        postId: json['postId'] ?? 0,
        conversationId: json['conversationId'] ?? '',
        type: json['type'] ?? '',
        status: json['status'] ?? '',
        //
        user: convertMapToUser(json['user']),
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
        post: convertMapToPost(json['post']),
        conversation: convertMapToConversation(json['conversation']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ReportedUser',
        'id': id,
        'userId': userId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'text': text,
        'postId': postId,
        'conversationId': conversationId,
        'type': type,
        'status': status,
        //
        'user': user,
        'userByCreatedBy': userByCreatedBy,
        'post': post,
        'conversation': conversation,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertReportedUserToMap(ReportedUser? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ReportedUser? convertMapToReportedUser(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ReportedUser.fromJson(json);
}

List<Map<String, dynamic>> convertReportedUsersToMaps(
    List<ReportedUser>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<ReportedUser> convertMapsToReportedUsers(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => ReportedUser.fromJson(e)).toList();
}

// ReportedUsers
class ReportedUsers {
  late List<ReportedUser> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  ReportedUsers({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory ReportedUsers.fromJson(Map<String, dynamic> json) => ReportedUsers(
        nodes: convertMapsToReportedUsers(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'ReportedUsersConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertReportedUsersToMap(ReportedUsers? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

ReportedUsers? convertMapToReportedUsers(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return ReportedUsers.fromJson(json);
}
