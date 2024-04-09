// To parse this JSON data, do
//
//     final journalResponse = journalResponseFromJson(jsonString);

import 'dart:convert';

JournalResponse journalResponseFromJson(String str) =>
    JournalResponse.fromJson(json.decode(str));

String journalResponseToJson(JournalResponse data) =>
    json.encode(data.toJson());

class JournalResponse {
  final bool? success;
  final List<Journal>? journal;

  JournalResponse({
    this.success,
    this.journal,
  });

  factory JournalResponse.fromJson(Map<String, dynamic> json) =>
      JournalResponse(
        success: json["success"],
        journal: json["data"] == null // Corrected key from "Journal" to "data"
            ? []
            : List<Journal>.from(json["data"].map((x) => Journal.fromJson(x))),
      );

  bool get isEmpty => journal?.isEmpty ?? true; // Implemented isEmpty correctly

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": journal == null // Corrected key from "Journal" to "data"
            ? []
            : List<dynamic>.from(journal!.map((x) => x.toJson())),
      };
}

class Journal {
  final int? journalId;
  final int? userId;
  final String? title;
  final String? entry;
  final DateTime? createdAt;
  final String? location;
  final String? mood;
  final String? featuredImage;

  Journal({
    this.journalId,
    this.userId,
    this.title,
    this.entry,
    this.createdAt,
    this.location,
    this.mood,
    this.featuredImage,
  });

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
        journalId: json["journal_id"],
        userId: json["user_id"],
        title: json["title"],
        entry: json["entry"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        location: json["location"],
        mood: json["mood"],
        featuredImage: json["featured_image"],
      );

  get id => journalId;

  Map<String, dynamic> toJson() => {
        "journal_id": journalId,
        "user_id": userId,
        "title": title,
        "entry": entry,
        "created_at": createdAt?.toIso8601String(),
        "location": location,
        "mood": mood,
        "featured_image": featuredImage,
      };
}
