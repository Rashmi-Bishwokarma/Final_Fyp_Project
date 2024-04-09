import 'dart:convert';

ToDoList toDoListFromJson(String str) => ToDoList.fromJson(json.decode(str));

String toDoListToJson(ToDoList data) => json.encode(data.toJson());

class ToDoList {
  final bool? success;
  final List<Task>? tasks;
  final String? message; // Added message field

  ToDoList({
    this.success,
    this.tasks,
    this.message, // Initialize message
  });

  factory ToDoList.fromJson(Map<String, dynamic> json) => ToDoList(
        success: json["success"],
        tasks: json["tasks"] == null
            ? null
            : List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
        message: json["message"], // Assign message from JSON
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "tasks": tasks == null
            ? null
            : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "message": message, // Include message in toJson
      };
}

class Task {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final String? startTime;
  final String? endTime;
  final String? priority;
  final DateTime? createdAt;

  Task({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.startTime,
    this.endTime,
    this.priority,
    this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        priority: json["priority"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "priority": priority,
        "created_at": createdAt?.toIso8601String(),
      };
}
