import 'dart:math';

class UserAddress {
  late String userId;
  late String details;
  late String street;
  late String district;
  late String city;
  late Point? location;

  UserAddress({
    this.userId = '',
    this.details = '',
    this.street = '',
    this.district = '',
    this.city = '',
    this.location,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        userId: json['userId'] ?? '',
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
        '__typename': 'UserAddress',
        'userId': userId,
        'details': details,
        'street': street,
        'district': district,
        'city': city,
        'location': location,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertUserAddressToMap(UserAddress? userAddress) {
  if (userAddress == null) {
    return null;
  }
  return userAddress.toJson();
}

UserAddress? convertMapToUserAddress(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return UserAddress.fromJson(json);
}

List<Map<String, dynamic>> convertUserAddressesToMaps(
    List<UserAddress>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<UserAddress> convertMapsToUserAddresses(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => UserAddress.fromJson(e)).toList();
}
