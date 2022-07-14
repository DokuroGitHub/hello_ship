import 'dart:math';

class PostAddress {
  late int postId;
  late String details;
  late String street;
  late String district;
  late String city;
  late Point? location;

  PostAddress({
    this.postId = 0,
    this.details = '',
    this.street = '',
    this.district = '',
    this.city = '',
    this.location,
  });

  factory PostAddress.fromJson(Map<String, dynamic> json) => PostAddress(
        postId: json['postId'] ?? 0,
        details: json['details'] ?? '',
        street: json['street'] ?? '',
        district: json['district'] ?? '',
        city: json['city'] ?? '',
        location:
            json['location']?['x'] != null && json['location']?['y'] != null
                ? Point(json['location']['x'], json['location']['y'])
                : null,
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'PostAddress',
        'postId': postId,
        'details': details,
        'street': street,
        'district': district,
        'city': city,
        'location': location,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertPostAddressToMap(PostAddress? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

PostAddress? convertMapToPostAddress(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return PostAddress.fromJson(json);
}

List<Map<String, dynamic>> convertPostAddresssToMaps(
    List<PostAddress>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<PostAddress> convertMapsToPostAddresss(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => PostAddress.fromJson(e)).toList();
}
