class Feedback {
  late int id;
  late String userId;
  late String createdBy;
  late DateTime? createdAt;
  late DateTime? editedAt;
  late DateTime? deletedAt;
  late double rating;
  late String text;

  Feedback({
    this.id = 0,
    this.userId = '',
    this.createdBy = '',
    this.createdAt,
    this.editedAt,
    this.deletedAt,
    this.rating = 0.0,
    this.text = '',
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
        id: json['id'] ?? 0,
        userId: json['userId'] ?? '',
        createdBy: json['createdBy'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        editedAt: DateTime.tryParse(json['editedAt'] ?? ''),
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        rating: json['rating'] ?? 0.0,
        text: json['text'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'Feedback',
        'id': id,
        'userId': userId,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'deletedAt': deletedAt,
        'rating': rating,
        'text': text,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertFeedbackToMap(Feedback? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Feedback? convertMapToFeedback(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Feedback.fromJson(json);
}

List<Map<String, dynamic>> convertFeedbacksToMaps(List<Feedback>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<Feedback> convertMapsToFeedbacks(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => Feedback.fromJson(e)).toList();
}

// Feedbacks
class Feedbacks {
  late List<Feedback> nodes;
  late int totalCount;

  Feedbacks({
    this.nodes = const [],
    this.totalCount = 0,
  });

  factory Feedbacks.fromJson(Map<String, dynamic> json) => Feedbacks(
        nodes: convertMapsToFeedbacks(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'FeedbacksConnection',
        'nodes': nodes,
        'totalCount': totalCount,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertFeedbacksToMap(Feedbacks? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Feedbacks? convertMapToFeedbacks(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Feedbacks.fromJson(json);
}
