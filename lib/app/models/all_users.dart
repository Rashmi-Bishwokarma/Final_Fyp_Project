class User {
  final String userId;
  final String fullName;
  final String password; // Note: Handle with care!
  final String email;
  final String role;
  final String? address;
  final String? dateOfBirth;
  final String? description;
  final String? profileImage;

  User({
    required this.userId,
    required this.fullName,
    required this.password, // Note: Handle with care!
    required this.email,
    required this.role,
    this.address,
    this.dateOfBirth,
    this.description,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      fullName: json['full_name'],
      password: json['password'], // Note: Handle with care!
      email: json['email'],
      role: json['role'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'],
      description: json['description'],
      profileImage: json['profile_image'],
    );
  }
}

class UsersList {
  final List<User> users;

  UsersList({required this.users});

  factory UsersList.fromJson(Map<String, dynamic> json) {
    var list = json['users'] as List;
    List<User> usersList = list.map((i) => User.fromJson(i)).toList();
    return UsersList(users: usersList);
  }
}
