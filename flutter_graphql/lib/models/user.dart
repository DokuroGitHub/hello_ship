class User {
  late String id;
  late String name;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late String email;
  late String role;

  User({
    this.id = '',
    this.name = '',
    this.createdAt,
    this.updatedAt,
    this.email = '',
    this.role = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        createdAt: DateTime.tryParse(json['createdAt']),
        updatedAt: DateTime.tryParse(json['updatedAt']),
        email: json['email'] ?? '',
        role: json['role'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "__typename": "User",
        "id": id,
        "name": name,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "email": email,
        "role": role,
      };

  @override
  String toString() => toJson().toString();
}
