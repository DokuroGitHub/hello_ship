import 'package:dokuro_flutter/models/feedback.dart';
import 'package:dokuro_flutter/models/page_info.dart';
import 'package:dokuro_flutter/models/user_address.dart';

import 'user_shipper.dart';

class User {
  late String id;
  late String uid;
  late DateTime? createdAt;
  late DateTime? deletedAt;
  late DateTime? blockedUntil;
  late DateTime? lastSeen;
  late String name;
  late String avatarUrl;
  late String coverUrl;
  late DateTime? birthdate;
  late String bios;
  // refs
  late UserAddress? userAddress;
  late UserShipper? userShipper;
  // others
  late String email;
  late String role;
  late String phone;
  //
  late Feedbacks? feedbacks;

  User({
    this.id = '',
    this.uid = '',
    this.createdAt,
    this.deletedAt,
    this.blockedUntil,
    this.lastSeen,
    this.name = '',
    this.avatarUrl = '',
    this.coverUrl = '',
    this.birthdate,
    this.bios = '',
    this.userAddress,
    this.userShipper,
    this.email = '',
    this.role = '',
    this.phone = '',
    this.feedbacks,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        uid: json['uid'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
        deletedAt: DateTime.tryParse(json['deletedAt'] ?? ''),
        blockedUntil: DateTime.tryParse(json['blockedUntil'] ?? ''),
        lastSeen: DateTime.tryParse(json['lastSeen'] ?? ''),
        name: json['name'] ?? '',
        avatarUrl: json['avatarUrl'] ?? '',
        coverUrl: json['coverUrl'] ?? '',
        birthdate: DateTime.tryParse(json['birthdate'] ?? ''),
        bios: json['bios'] ?? '',
        userAddress: convertMapToUserAddress(json['userAddress']),
        userShipper: convertMapToUserShipper(json['userShipper']),
        email: json['email'] ?? '',
        role: json['role'] ?? '',
        phone: json['phone'] ?? '',
        feedbacks: convertMapToFeedbacks(json['feedbacks']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'User',
        'id': id,
        'uid': uid,
        'createdAt': createdAt,
        'deletedAt': deletedAt,
        'blockedUntil': blockedUntil,
        'lastSeen': lastSeen,
        'name': name,
        'avatarUrl': avatarUrl,
        'coverUrl': coverUrl,
        'birthdate': birthdate,
        'bios': bios,
        'userAddress': convertUserAddressToMap(userAddress),
        'userShipper': convertUseShipperToMap(userShipper),
        'email': email,
        'role': role,
        'phone': phone,
        'feedbacks': feedbacks,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertUserToMap(User? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

User? convertMapToUser(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return User.fromJson(json);
}

List<Map<String, dynamic>> convertUsersToMaps(List<User>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<User> convertMapsToUsers(List? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => User.fromJson(e)).toList();
}

// Users
class Users {
  late List<User> nodes;
  late int totalCount;
  late PageInfo? pageInfo;

  Users({
    this.nodes = const [],
    this.totalCount = 0,
    this.pageInfo,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        nodes: convertMapsToUsers(json['nodes']),
        totalCount: json['totalCount'] ?? 0,
        pageInfo: convertMapToPageInfo(json['pageInfo']),
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'UsersConnection',
        'nodes': nodes,
        'totalCount': totalCount,
        'pageInfo': pageInfo,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertUsersToMap(Users? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

Users? convertMapToUsers(Map<String, dynamic>? map) {
  if (map == null) {
    return null;
  }
  return Users.fromJson(map);
}
