import 'dart:convert';

ChangePassword changePasswordFromJson(String str) =>
    ChangePassword.fromJson(json.decode(str));

String changePasswordToJson(ChangePassword data) => json.encode(data.toJson());

class ChangePassword {
  final bool? success;
  final String? message;

  ChangePassword({
    this.success,
    this.message,
  });

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
