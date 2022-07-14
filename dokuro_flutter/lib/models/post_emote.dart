import 'user.dart';

class PostEmote {
  late int id;
  late int postId;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late String code;
  //
  late User? userByCreatedBy;

  PostEmote({
    this.id = 0,
    this.postId = 0,
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.code = '',
    this.userByCreatedBy,
  });

  factory PostEmote.fromJson(Map<String, dynamic> json) => PostEmote(
        id: json['id'] ?? 0,
        postId: json['postId'] ?? 0,
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        code: json['code'] ?? '',
        userByCreatedBy: convertMapToUser(json['userByCreatedBy']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostEmote',
        'id': id,
        'postId': postId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'editedAt': editedAt,
        'code': code,
        'userByCreatedBy': userByCreatedBy,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPostEmoteToMap(PostEmote? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PostEmote? convertMapToPostEmote(Map<String, dynamic>? map) {
  if (map == null) {
    return null;
  }
  return PostEmote.fromJson(map);
}

List<Map<String, dynamic>> convertPostEmotesToMaps(List<PostEmote>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<PostEmote> convertMapsToPostEmotes(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => PostEmote.fromJson(e)).toList();
}

// PostEmotes
class PostEmotes {
  late List<PostEmote> nodes;
  late int totalCount;
  //
  //late EmotesCount? emotesCount;
  late bool hasCurrentUserId;

  PostEmotes({
    this.nodes = const [],
    this.totalCount = 0,
    //this.emotesCount,
    this.hasCurrentUserId = false,
  });

  factory PostEmotes.fromJson(Map<String, dynamic> json) => PostEmotes(
        nodes: convertMapsToPostEmotes(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        //emotesCount: convertMapToEmotesCount(json['emotesCount']),
        hasCurrentUserId: json['hasCurrentUserId'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostEmotesConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        //'emotesCount': emotesCount,
        'hasCurrentUserId': hasCurrentUserId,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPostEmotesToMap(PostEmotes? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PostEmotes? convertMapToPostEmotes(Map<String, dynamic>? map) {
  if (map == null) {
    return null;
  }
  return PostEmotes.fromJson(map);
}
