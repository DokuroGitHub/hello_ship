import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/post_address.dart';
import 'package:dokuro_flutter/models/post_attachment.dart';
import 'package:dokuro_flutter/models/post_comment.dart';
import 'package:dokuro_flutter/models/post_emote.dart';
import 'package:dokuro_flutter/models/shipment.dart';
import 'package:dokuro_flutter/models/user.dart';
import 'package:flutter/cupertino.dart';

class Post {
  late int id;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late String deletedBy;
  late DateTime? deletedAt;
  late String text;
  late int shipmentId;
  //
  late PostAddress? postAddress;
  late PostAttachments? postAttachments;
  late PostComments? postComments;
  late Shipment? shipment;
  late User? userByCreatedBy;
  // emotes
  late PostEmotes? emoteByCurrentUserId;
  late PostEmotes? emotesByLike;
  late PostEmotes? emotesByLove;
  late PostEmotes? emotesByCare;
  late PostEmotes? emotesByHaha;
  late PostEmotes? emotesByWow;
  late PostEmotes? emotesBySad;
  late PostEmotes? emotesByAngry;

  Post({
    this.id = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.deletedBy = '',
    this.deletedAt,
    this.text = '',
    this.shipmentId = 0,
    //
    this.postAddress,
    this.postAttachments,
    this.postComments,
    this.shipment,
    this.userByCreatedBy,
    // emotes
    this.emoteByCurrentUserId,
    this.emotesByLike,
    this.emotesByLove,
    this.emotesByCare,
    this.emotesByHaha,
    this.emotesByWow,
    this.emotesBySad,
    this.emotesByAngry,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        deletedBy: json['deletedBy'] ?? '',
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        text: json['text'] ?? '',
        shipmentId: json['shipmentId'] ?? 0,
        //
        postAddress: convertMapToPostAddress(json['postAddress']),
        postAttachments: convertMapToPostAttachments(json['postAttachments']),
        postComments: convertMapToPostComments(json['postComments']),
        shipment: convertMapToShipment(json['shipment']),
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
        // emotes
        emoteByCurrentUserId:
            convertMapToPostEmotes(json['emoteByCurrentUserId']),
        emotesByLike: convertMapToPostEmotes(json['emotesByLike']),
        emotesByLove: convertMapToPostEmotes(json['emotesByLove']),
        emotesByCare: convertMapToPostEmotes(json['emotesByCare']),
        emotesByHaha: convertMapToPostEmotes(json['emotesByHaha']),
        emotesByWow: convertMapToPostEmotes(json['emotesByWow']),
        emotesBySad: convertMapToPostEmotes(json['emotesBySad']),
        emotesByAngry: convertMapToPostEmotes(json['emotesByAngry']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'Post',
        'id': id,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'deletedBy': deletedBy,
        'deletedAt': deletedAt,
        'text': text,
        'shipmentId': shipmentId,
        //
        'postAddress': postAddress,
        'postAttachments': postAttachments,
        'postComments': postComments,
        'shipment': shipment,
        'userByCreatedBy': userByCreatedBy,
        // emotes
        'emoteByCurrentUserId': emoteByCurrentUserId,
        'emotesByLike': emotesByLike,
        'emotesByLove': emotesByLove,
        'emotesByCare': emotesByCare,
        'emotesByHaha': emotesByHaha,
        'emotesByWow': emotesByWow,
        'emotesBySad': emotesBySad,
        'emotesByAngry': emotesByAngry,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPostToMap(Post? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Post? convertMapToPost(Map<String, dynamic>? json) {
  debugPrint('convertMapToPost');
  if (json == null) {
    return null;
  }
  return Post.fromJson(json);
}

List<Map<String, dynamic>> convertPostsToMaps(List<Post> entities) {
  return entities.map((e) => e.toJson()).toList();
}

List<Post> convertMapsToPosts(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => Post.fromJson(e)).toList();
}

// Posts
class Posts {
  late List<Post> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  Posts({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        nodes: convertMapsToPosts(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPostsToMap(Posts? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Posts? convertMapToPosts(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Posts.fromJson(json);
}
