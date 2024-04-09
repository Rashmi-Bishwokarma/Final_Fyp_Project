class FeedbackItem {
  final String id;
  final String userId;
  final String message;
  final int? rating; // Nullable because your JSON shows it can be null
  final DateTime createdAt;
  final String username;
  final String email;
  final String? profileImage; // Nullable because your JSON shows it can be null

  FeedbackItem({
    required this.id,
    required this.userId,
    required this.message,
    this.rating,
    required this.createdAt,
    required this.username,
    required this.email,
    this.profileImage,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      message: json['message'] as String,
      rating: json.containsKey('rating') && json['rating'] != null
          ? int.parse(json['rating'])
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      username: json['username'] as String,
      email: json['email'] as String,
      profileImage: json['profile_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'username': username,
      'email': email,
      'profile_image': profileImage,
    };
  }
}
