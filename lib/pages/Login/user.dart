

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      role: UserRoleExtension.fromString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role.value,
    };
  }
}
enum UserRole { User, Admin }

extension UserRoleExtension on UserRole {
  String get value => toString().split('.').last;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
          (e) => e.value.toLowerCase() == role.toLowerCase(),
      orElse: () => UserRole.User,
    );
  }
}

