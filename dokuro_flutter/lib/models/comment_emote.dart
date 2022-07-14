import 'user.dart';

// CommentEmote
class CommentEmote {
  late int id;
  late int commentId;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late String code;
  //
  late User? userByCreatedBy;

  CommentEmote({
    this.id = 0,
    this.commentId = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.code = '',
    this.userByCreatedBy,
  });

  factory CommentEmote.fromJson(Map<String, dynamic> json) => CommentEmote(
        id: json['id'] ?? 0,
        commentId: json['commentId'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        code: json['code'] ?? '',
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'CommentEmote',
        'id': id,
        'commentId': commentId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'code': code,
        'userByCreatedBy': userByCreatedBy,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertCommentEmoteToMap(CommentEmote? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

CommentEmote? convertMapToCommentEmote(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return CommentEmote.fromJson(json);
}

List<Map<String, dynamic>> convertCommentEmotesToMaps(
    List<CommentEmote>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<CommentEmote> convertMapsToCommentEmotes(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => CommentEmote.fromJson(e)).toList();
}

// CommentEmotes
class CommentEmotes {
  late List<CommentEmote> nodes;
  late int totalCount;
  //
  //late EmotesCount? emotesCount;
  //late bool hasCurrentUserId;

  CommentEmotes({
    this.nodes = const [],
    this.totalCount = 0,
    //this.emotesCount,
    //this.hasCurrentUserId = false,
  });

  factory CommentEmotes.fromJson(Map<String, dynamic> json) => CommentEmotes(
        nodes: convertMapsToCommentEmotes(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        //emotesCount: convertMapToEmotesCount(json['emotesCount']),
        //hasCurrentUserId: json['hasCurrentUserId'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'CommentEmotesConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        //'emotesCount': emotesCount,
        //'hasCurrentUserId': hasCurrentUserId,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertCommentEmotesToMap(CommentEmotes? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

CommentEmotes? convertMapToCommentEmotes(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return CommentEmotes.fromJson(json);
}
