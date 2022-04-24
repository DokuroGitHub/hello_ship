class UserAccount {
  late String userId;
  late String username;
  late String email;
  late String password;
  late String passwordHash;
  late String role;

  UserAccount({
    this.userId = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.passwordHash = '',
    this.role = '',
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        userId: json['userId'] ?? 0,
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        passwordHash: json['passwordHash'] ?? '',
        role: json['role'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "__typename": "UserAccount",
        "userId": userId,
        "username": username,
        "email": email,
        "password": password,
        "passwordHash": passwordHash,
        "role": role,
      };

  @override
  String toString() => toJson().toString();
}
