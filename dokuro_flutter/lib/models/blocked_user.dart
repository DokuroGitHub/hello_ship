class BlockedUser {
  late int id;
  late String userId;
  late String createdBy;
  late DateTime? blockedUntil;

  BlockedUser({
    this.id = 0,
    this.userId = '',
    this.createdBy = '',
    this.blockedUntil,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) => BlockedUser(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        createdBy: json['createdBy'] ?? '',
        blockedUntil: DateTime.tryParse(json['blockedUntil'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'BlockedUser',
        'id': id,
        'userId': userId,
        'createdBy': createdBy,
        'blockedUntil': blockedUntil,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertBlockedUserToMap(BlockedUser? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

BlockedUser? convertMapToBlockedUser(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return BlockedUser.fromJson(json);
}

List<Map<String, dynamic>> convertBlockedUsersToMaps(
    List<BlockedUser>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<BlockedUser> convertMapsToBlockedUsers(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => BlockedUser.fromJson(e)).toList();
}
