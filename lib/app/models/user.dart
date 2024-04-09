import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  bool? success;
  String? message;
  User? user;

  UserResponse({
    this.success,
    this.message,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        success: json["success"],
        message: json["message"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user?.toJson(),
      };
}

class User {
  String? userId;
  String? email;
  String? fullName;
  String? role;
  String? address;
  String? dateOfBirth;
  String? description;
  String? profileImage;

  User({
    this.userId,
    this.email,
    this.fullName,
    this.role,
    this.address,
    this.dateOfBirth,
    this.description,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        fullName: json["full_name"],
        role: json["role"],
        address: json["address"],
        dateOfBirth: json["date_of_birth"],
        description: json["description"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "full_name": fullName,
        "role": role,
        "address": address,
        "date_of_birth": dateOfBirth,
        "description": description,
        "profile_image": profileImage,
      };
}
