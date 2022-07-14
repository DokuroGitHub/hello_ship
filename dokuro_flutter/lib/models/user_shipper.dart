class UserShipper {
  late String userId;
  late String vehicleType;
  late String vehicleDescription;
  late DateTime? createdAt;
  late String status;

  UserShipper({
    this.userId = '',
    this.vehicleType = '',
    this.vehicleDescription = '',
    this.createdAt,
    this.status = '',
  });

  factory UserShipper.fromJson(Map<String, dynamic> json) => UserShipper(
        userId: json['userId'] ?? '',
        vehicleType: json['vehicleType'] ?? '',
        vehicleDescription: json['vehicleDescription'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt']),
        status: json['status'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'UserShipper',
        'userId': userId,
        'vehicleType': vehicleType,
        'vehicleDescription': vehicleDescription,
        'createdAt': createdAt,
        'status': status,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertUseShipperToMap(UserShipper? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

UserShipper? convertMapToUserShipper(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return UserShipper.fromJson(json);
}

List<Map<String, dynamic>> convertUserShippersToMaps(
    List<UserShipper>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<UserShipper> convertMapsToUserShippers(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => UserShipper.fromJson(e)).toList();
}