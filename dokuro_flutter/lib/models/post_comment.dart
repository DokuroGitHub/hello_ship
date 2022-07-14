import 'package:dokuro_flutter/models/comment_attachment.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user.dart';

import 'comment_emote.dart';

enum CommentsOrderBy {
  idAsc,
  idDesc,
}

class PostComment {
  late int id;
  late int postId;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late DateTime? deletedAt;
  late String text;
  late int replyTo;
  //
  late CommentAttachments? commentAttachmentsByCommentId;
  late User? userByCreatedBy;
  late PostComment? postCommentByReplyTo;
  late PostComments? postCommentsByReplyTo;
  // emotes
  late CommentEmotes? emoteByCurrentUserId;
  late CommentEmotes? emotesByLike;
  late CommentEmotes? emotesByLove;
  late CommentEmotes? emotesByCare;
  late CommentEmotes? emotesByHaha;
  late CommentEmotes? emotesByWow;
  late CommentEmotes? emotesBySad;
  late CommentEmotes? emotesByAngry;

  PostComment({
    this.id = 0,
    this.postId = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.text = '',
    this.replyTo = 0,
    this.commentAttachmentsByCommentId,
    this.userByCreatedBy,
    this.postCommentByReplyTo,
    this.postCommentsByReplyTo,
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

  factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
        id: json['id'] ?? 0,
        postId: json['postId'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        text: json['text'] ?? '',
        replyTo: json['replyTo'] ?? 0,
        commentAttachmentsByCommentId: convertMapToCommentAttachments(
            json['commentAttachmentsByCommentId']),
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
        postCommentByReplyTo:
            convertMapToPostComment(json['postCommentByReplyTo']),
        postCommentsByReplyTo:
            convertMapToPostComments(json['postCommentsByReplyTo']),
        // emotes
        emoteByCurrentUserId:
            convertMapToCommentEmotes(json['emoteByCurrentUserId']),
        emotesByLike: convertMapToCommentEmotes(json['emotesByLike']),
        emotesByLove: convertMapToCommentEmotes(json['emotesByLove']),
        emotesByCare: convertMapToCommentEmotes(json['emotesByCare']),
        emotesByHaha: convertMapToCommentEmotes(json['emotesByHaha']),
        emotesByWow: convertMapToCommentEmotes(json['emotesByWow']),
        emotesBySad: convertMapToCommentEmotes(json['emotesBySad']),
        emotesByAngry: convertMapToCommentEmotes(json['emotesByAngry']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostComment',
        'id': id,
        'postId': postId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'deletedAt': deletedAt,
        'text': text,
        'replyTo': replyTo,
        'commentAttachmentsByCommentId': commentAttachmentsByCommentId,
        'userByCreatedBy': userByCreatedBy,
        'postCommentByReplyTo': postCommentByReplyTo,
        'postCommentsByReplyTo': postCommentsByReplyTo,
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

class PostComments {
  late List<PostComment> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  PostComments({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory PostComments.fromJson(Map<String, dynamic> json) => PostComments(
        nodes: convertMapsToPostComments(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostCommentsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPostCommentToMap(PostComment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PostComment? convertMapToPostComment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return PostComment.fromJson(json);
}

List<Map<String, dynamic>> convertPostCommentsToMaps(
    List<PostComment> entities) {
  return entities.map((e) => e.toJson()).toList();
}

List<PostComment> convertMapsToPostComments(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => PostComment.fromJson(e)).toList();
}

// PostComments
Map<String, dynamic>? convertPostCommentsToMap(PostComments? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PostComments? convertMapToPostComments(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return PostComments.fromJson(json);
}
