class JournalResponse {
  final bool success;
  final List<Journal> data;

  JournalResponse({required this.success, required this.data});

  // Deserialize the JSON
  factory JournalResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Journal> journalsList =
        list.map((i) => Journal.fromJson(i as Map<String, dynamic>)).toList();
    return JournalResponse(
      success: json['success'],
      data: journalsList,
    );
  }
}

class Journal {
  final int journalId;
  final String title;
  final String entry;
  final String location;
  final String mood;
  final String? featuredImage; // Nullable because it can be null
  final DateTime createdAt; // Changed to DateTime for proper date handling
  final String fullName;
  final String? profileImage; // Nullable because it can be null
  late final int likeCount;
  bool isLiked; // Added the isLiked property

  Journal({
    required this.journalId,
    required this.title,
    required this.entry,
    required this.location,
    required this.mood,
    this.featuredImage,
    required this.createdAt, // Ensure this is initialized as a DateTime
    required this.fullName,
    this.profileImage,
    required this.likeCount,
    required this.isLiked, // Defaulting to false, change based on your logic
  });

  // A method to deserialize the JSON
  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      journalId: int.parse(json['journal_id'].toString()),
      title: json['title'] ?? '',
      entry: json['entry'] ?? '',
      location: json['location'] ?? '',
      mood: json['mood'] ?? '',
      featuredImage: json['featured_image'],
      createdAt: DateTime.parse(json['created_at'].toString()),
      fullName: json['full_name'] ?? '',
      profileImage: json['profile_image'],
      likeCount: json['like_count'] != null
          ? int.parse(json['like_count'].toString())
          : 0,
      isLiked: json['is_liked'] == 1,
    );
  }
}
