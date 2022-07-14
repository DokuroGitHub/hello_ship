class PageInfo {
  late String? startCursor;
  late String? endCursor;
  late bool hasPreviousPage;
  late bool hasNextPage;

  PageInfo({
    this.startCursor,
    this.endCursor,
    this.hasPreviousPage = false,
    this.hasNextPage = false,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        startCursor: json['startCursor'],
        endCursor: json['endCursor'],
        hasPreviousPage: json['hasPreviousPage'] ?? false,
        hasNextPage: json['hasNextPage'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PageInfo',
        'startCursor': startCursor,
        'endCursor': endCursor,
        'hasPreviousPage': hasPreviousPage,
        'hasNextPage': hasNextPage,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPageInfoToMap(PageInfo? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PageInfo? convertMapToPageInfo(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return PageInfo.fromJson(json);
}

