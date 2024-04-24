class TableCounts {
  int comments,
      feedback,
      journals,
      journalTags,
      likes,
      notes,
      notifications,
      payments,
      personalAccessToken,
      plans,
      subscriptions,
      tags,
      tasks,
      users;

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
      comments: int.tryParse(json['comments'].toString()) ?? 0,
      feedback: int.tryParse(json['feedback'].toString()) ?? 0,
      journals: int.tryParse(json['journals'].toString()) ?? 0,
      journalTags: int.tryParse(json['journal_tags'].toString()) ?? 0,
      likes: int.tryParse(json['likes'].toString()) ?? 0,
      notes: int.tryParse(json['notes'].toString()) ?? 0,
      notifications: int.tryParse(json['notifications'].toString()) ?? 0,
      payments: int.tryParse(json['payments'].toString()) ?? 0,
      personalAccessToken:
          int.tryParse(json['personal_access_token'].toString()) ?? 0,
      plans: int.tryParse(json['plans'].toString()) ?? 0,
      subscriptions: int.tryParse(json['subscriptions'].toString()) ?? 0,
      tags: int.tryParse(json['tags'].toString()) ?? 0,
      tasks: int.tryParse(json['tasks'].toString()) ?? 0,
      users: int.tryParse(json['users'].toString()) ?? 0,
    );
  }
}

class JournalCount {
  String date;
  int count;

  JournalCount({required this.date, required this.count});

  factory JournalCount.fromJson(Map<String, dynamic> json) {
    return JournalCount(
      date: json['date'],
      count: int.tryParse(json['count'].toString()) ?? 0,
    );
  }
}
