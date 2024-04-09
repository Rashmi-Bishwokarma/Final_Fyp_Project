class JournalCountResponse {
  final List<JournalCount> journalCounts;

  JournalCountResponse({required this.journalCounts});

  factory JournalCountResponse.fromJson(Map<String, dynamic> json) {
    var list = json['journal_counts'] as List;
    List<JournalCount> journalCountsList =
        list.map((i) => JournalCount.fromJson(i)).toList();
    return JournalCountResponse(journalCounts: journalCountsList);
  }
}

class JournalCount {
  final String date;
  final int count;

  JournalCount({required this.date, required this.count});

  factory JournalCount.fromJson(Map<String, dynamic> json) {
    return JournalCount(
      date: json['date'],
      count: int.parse(json['count']),
    );
  }
}
