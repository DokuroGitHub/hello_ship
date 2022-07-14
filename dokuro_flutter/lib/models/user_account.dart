class UserAccount {
  late String userId;
  late String email;
  late String phone;
  late String username;
  late String password;
  late String passwordHash;
  late String role;

  UserAccount({
    this.userId = '',
    this.email = '',
    this.phone = '',
    this.username = '',
    this.password = '',
    this.passwordHash = '',
    this.role = '',
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        userId: json['userId'] ?? 0,
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        username: json['username'] ?? '',
        password: json['password'] ?? '',
        passwordHash: json['passwordHash'] ?? '',
        role: json['role'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        '__typename': 'UserAccount',
        'userId': userId,
        'email': email,
        'phone': phone,
        'username': username,
        'password': password,
        'passwordHash': passwordHash,
        'role': role,
      };

  @override
  String toString() => toJson().toString();
}

Map<String, dynamic>? convertUserAccountToMap(UserAccount? entity) {
  if (entity == null) {
    return null;
  }
  return entity.toJson();
}

UserAccount? convertMapToUserAccount(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return UserAccount.fromJson(json);
}

List<Map<String, dynamic>> convertUserAccountsToMaps(
    List<UserAccount>? entities) {
  if (entities == null) {
    return [];
  }
  return entities.map((e) => e.toJson()).toList();
}

List<UserAccount> convertMapsToUserAccounts(List<Map<String, dynamic>>? maps) {
  if (maps == null) {
    return [];
  }
  return maps.map((e) => UserAccount.fromJson(e)).toList();
}
