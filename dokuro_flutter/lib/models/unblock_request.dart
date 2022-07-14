import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:flutter/cupertino.dart';

class UnblockRequest {
  late int id;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late String text;
  late String status;
  late String checkedBy;
  late DateTime? checkedAt;
  //
  late User? userByCreatedBy;
  late User? userByCheckedBy;

  UnblockRequest({
    this.id = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.text = '',
    this.status = '',
    this.checkedBy = '',
    this.checkedAt,
    //
    this.userByCreatedBy,
    this.userByCheckedBy,
  });

  factory UnblockRequest.fromJson(Map<String, dynamic> json) => UnblockRequest(
        id: json['id'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        text: json['text'] ?? '',
        status: json['status'] ?? '',
        checkedBy: json['checkedBy'] ?? '',
        checkedAt: DateTime.tryParse(json['checkedAt'] ?? ''),
        //
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
        userByCheckedBy: convertMapToUser(json['userByCheckedBy']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'UnblockRequest',
        'id': id,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'text': text,
        'status': status,
        'checkedBy': checkedBy,
        'checkedAt': checkedAt,
        //
        'userByCreatedBy': userByCreatedBy,
        'userByCheckedBy': userByCheckedBy,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertUnblockRequestToMap(UnblockRequest? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

UnblockRequest? convertMapToUnblockRequest(Map<String, dynamic>? json) {
  debugPrint('convertMapToUnblockRequest');
  if (json == null) {
    return null;
  }
  return UnblockRequest.fromJson(json);
}

List<Map<String, dynamic>> convertUnblockRequestsToMaps(
    List<UnblockRequest> entities) {
  return entities.map((e) => e.toJson()).toList();
}

List<UnblockRequest> convertMapsToUnblockRequests(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => UnblockRequest.fromJson(e)).toList();
}

// UnblockRequests
class UnblockRequests {
  late List<UnblockRequest> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  UnblockRequests({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory UnblockRequests.fromJson(Map<String, dynamic> json) =>
      UnblockRequests(
        nodes: convertMapsToUnblockRequests(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'UnblockRequestsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertUnblockRequestsToMap(UnblockRequests? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

UnblockRequests? convertMapToUnblockRequests(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return UnblockRequests.fromJson(json);
}
