import 'package:fyp_rememory/app/models/to_do_list.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';

class ToDoListController extends GetxController {
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;
  // Ensure notes is a map from DateTime to a list of strings
  var notes = <DateTime, List<String>>{}
      .obs; // Correctly typed as RxMap<DateTime, List<String>>

  // Method to handle day selection
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
  }

  var todoList =
      Rx<ToDoList?>(null); // Use Rx for reactive programming with GetX
  bool hasTasksForDay(DateTime day) {
    if (todoList.value == null) {
      return false;
    }
    return todoList.value!.tasks!.any((task) {
      // Assuming task.startDate is a DateTime
      return isSameDay(task.startDate, day);
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    Uri url = Uri.http(
        ipAddress, 'rememory_api/getTasks'); // Adjust endpoint as needed

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {"token": Memory.getToken()}, // Using Memory class to get token
      );

      if (response.statusCode == 200) {
        final result = toDoListFromJson(response.body);

        if (result.success ?? false) {
          todoList.value = result;
          update(); // Notify listeners for update
        } else {
          // Handle failure (e.g., display a message)
          if (kDebugMode) {
            print("Failed to fetch tasks: ${result.message}");
          }
        }
      } else {
        // Handle HTTP errors (e.g., display a message)
        if (kDebugMode) {
          print("Server error: ${response.reasonPhrase}");
        }
      }
    } catch (e) {
      // Handle exceptions (e.g., display a message)
      if (kDebugMode) {
        print("Exception caught: $e");
      }
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String startDate,
    required String startTime,
    required String endTime,
    required String priority,
  }) async {
    // Implementation of the method
    // This should include validation of the input and a call to your backend API
    // to actually add the task with these details
    Uri url = Uri.http(ipAddress, 'rememory_api/addTasks'); // Example API call

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory
              .getToken(), // Assuming you're using a token for authentication
          'title': title,
          'description': description,
          'start_date': startDate,
          'start_time': startTime,
          'end_time': endTime,
          'priority': priority,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        if (kDebugMode) {
          print('Task added successfully');
        }
        fetchTasks(); // This should fetch the updated list and call update()
      } else {
        if (kDebugMode) {
          print('Failed to add task: ${responseData['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding task: $e');
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    Uri url = Uri.http(ipAddress,
        'rememory_api/deleteTask'); // Adjust with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory.getToken(),
          'id': taskId,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        if (kDebugMode) {
          print('Task deleted successfully');
        }
        // Assuming tasks is a List in ToDoList
        todoList.value?.tasks
            ?.removeWhere((task) => task.id.toString() == taskId);
        todoList.refresh(); // If todoList is Rx<ToDoList>, this should work.
        // Or, if the above doesn't work, try:
        update(); // This will force an update in all listeners.
      } else {
        if (kDebugMode) {
          print('Failed to delete task: ${responseData['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting task: $e');
      }
    }
  }

  Future<void> editTask({
    required String taskId,
    required String title,
    String? description,
    required String startDate,
    required String startTime,
    required String endTime,
    required String priority,
  }) async {
    Uri url = Uri.http(ipAddress,
        'rememory_api/editTask'); // Adjust with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory
              .getToken(), // Assuming you're using a token for authentication
          'id': taskId, // Task ID to identify which task to edit
          'title': title,
          'description': description,
          'start_date': startDate,
          'start_time': startTime,
          'end_time': endTime,
          'priority': priority,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        if (kDebugMode) {
          print('Task edited successfully');
        }
        fetchTasks(); // Refresh the task list to show the updated task
      } else {
        if (kDebugMode) {
          print('Failed to edit task: ${responseData['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error editing task: $e');
      }
    }
  }
}
