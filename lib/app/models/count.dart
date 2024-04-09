class TableCounts {
  final int comments;
  final int feedback;
  final int journals;
  final int journalTags;
  final int likes;
  final int notes;
  final int notifications;
  final int payments;
  final int personalAccessToken;
  final int plans;
  final int subscriptions;
  final int tags;
  final int tasks;
  final int users;

  TableCounts({
    required this.comments,
    required this.feedback,
    required this.journals,
    required this.journalTags,
    required this.likes,
    required this.notes,
    required this.notifications,
    required this.payments,
    required this.personalAccessToken,
    required this.plans,
    required this.subscriptions,
    required this.tags,
    required this.tasks,
    required this.users,
  });

  factory TableCounts.fromJson(Map<String, dynamic> json) {
    return TableCounts(
      comments: int.parse(json['comments']),
      feedback: int.parse(json['feedback']),
      journals: int.parse(json['journals']),
      journalTags: int.parse(json['journal_tags']),
      likes: int.parse(json['likes']),
      notes: int.parse(json['notes']),
      notifications: int.parse(json['notifications']),
      payments: int.parse(json['payments']),
      personalAccessToken: int.parse(json['personal_access_token']),
      plans: int.parse(json['plans']),
      subscriptions: int.parse(json['subscriptions']),
      tags: int.parse(json['tags']),
      tasks: int.parse(json['tasks']),
      users: int.parse(json['users']),
    );
  }
}
