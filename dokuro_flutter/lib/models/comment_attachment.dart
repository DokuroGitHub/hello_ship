
class CommentAttachment {
  late int id;
  late int commentId;
  late String fileUrl;
  late String thumbUrl;
  late String type;

  CommentAttachment({
    this.id = 0,
    this.commentId = 0,
    this.fileUrl = '',
    this.thumbUrl = '',
    this.type = '',
  });

  factory CommentAttachment.fromJson(Map<String, dynamic> json) =>
      CommentAttachment(
        id: json['id'] ?? 0,
        commentId: json['commentId'] ?? 0,
        fileUrl: json['fileUrl'] ?? '',
        thumbUrl: json['thumbUrl'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'CommentAttachment',
        'id': id,
        'commentId': commentId,
        'fileUrl': fileUrl,
        'thumbUrl': thumbUrl,
        'type': type,
      };

  @override
  String toString() => toJson().toString();
}


class CommentAttachments {
  late List<CommentAttachment> nodes;
  late int totalCount;

  CommentAttachments({
    this.nodes = const [],
    this.totalCount = 0,
  });

  factory CommentAttachments.fromJson(Map<String, dynamic> json) =>
      CommentAttachments(
        nodes: convertMapsToCommentAttachments(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'CommentAttachmentsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertCommentAttachmentToMap(CommentAttachment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

CommentAttachment? convertMapToCommentAttachment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return CommentAttachment.fromJson(json);
}

List<Map<String, dynamic>> convertCommentAttachmentToMaps(List<CommentAttachment>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<CommentAttachment> convertMapsToCommentAttachments(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => CommentAttachment.fromJson(e)).toList();
}

// CommentAttachments
Map<String, dynamic>? convertCommentAttachmentsToMap(CommentAttachments? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

CommentAttachments? convertMapToCommentAttachments(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return CommentAttachments.fromJson(json);
}
