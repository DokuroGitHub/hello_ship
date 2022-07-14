class PostAttachment {
  late int id;
  late int postId;
  late String fileUrl;
  late String thumbUrl;
  late String type;

  PostAttachment({
    this.id = 0,
    this.postId = 0,
    this.fileUrl = '',
    this.thumbUrl = '',
    this.type = '',
  });

  factory PostAttachment.fromJson(Map<String, dynamic> json) => PostAttachment(
        id: json['id'] ?? 0,
        postId: json['postId'] ?? 0,
        fileUrl: json['fileUrl'] ?? '',
        thumbUrl: json['thumbUrl'] ?? '',
        type: json['type'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostAttachment',
        'id': id,
        'postId': postId,
        'fileUrl': fileUrl,
        'thumbUrl': thumbUrl,
        'type': type,
      };

  @override
  String toString() => toJson().toString();
}

class PostAttachments {
  late List<PostAttachment> nodes;
  late int totalCount;

  PostAttachments({
    this.nodes = const [],
    this.totalCount = 0,
  });

  factory PostAttachments.fromJson(Map<String, dynamic> json) =>
      PostAttachments(
        nodes: convertMapsToPostAttachments(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostAttachmentsConnection',
        'nodes': nodes,
        'totalCount': totalCount,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPostAttachmentToMap(PostAttachment? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PostAttachment? convertMapToPostAttachment(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return PostAttachment.fromJson(json);
}

List<Map<String, dynamic>> convertPostAttachmentToMaps(
    List<PostAttachment>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<PostAttachment> convertMapsToPostAttachments(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => PostAttachment.fromJson(e)).toList();
}

// PostAttachments
Map<String, dynamic>? convertPostAttachmentsToMap(PostAttachments? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PostAttachments? convertMapToPostAttachments(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return PostAttachments.fromJson(json);
}
