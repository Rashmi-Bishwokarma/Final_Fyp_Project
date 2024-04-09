import 'package:fyp_rememory/app/models/note.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Adjust this to point to where you've stored your Memory class

class ShowNoteController extends GetxController {
  var isLoading = false.obs;

  RxList<Note> notes = RxList<Note>();
  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    isLoading(true);
    final Uri url = Uri.http(
        ipAddress, 'rememory_api/getNote'); // Replace with your actual endpoint

    try {
      final response = await http.post(
        url,
        body: {
          'token': Memory.getToken(), // Replace with your token retrieval logic
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        final notesJson = responseData['notes'] as List<dynamic>;
        final fetchedNotes = notesJson
            .map((noteJson) => Note.fromJson(noteJson as Map<String, dynamic>))
            .toList();
        notes.assignAll(fetchedNotes);
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch notes: ${responseData['message']}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while fetching notes: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<bool> deleteNote(int noteId) async {
    final Uri url = Uri.http(ipAddress,
        'rememory_api/deleteNote'); // Replace with your actual endpoint
    try {
      final response = await http.post(
        url,
        body: {
          'token': Memory.getToken(), // Replace with your token retrieval logic
          'note_id': noteId.toString(),
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        notes.removeWhere((note) => note.id == noteId);
        Get.snackbar('Success', 'Note deleted successfully');
        return true;
      } else {
        Get.snackbar(
            'Error', 'Failed to delete note: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the note: $e');
      return false;
    }
  }

  Future<bool> editNote(int noteId, String newContent) async {
    final Uri url = Uri.http(ipAddress,
        'rememory_api/editNote'); // Replace with your actual endpoint
    try {
      final response = await http.post(
        url,
        body: {
          'token': Memory.getToken(), // Replace with your token retrieval logic
          'note_id': noteId.toString(),
          'content': newContent,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        // Find the note in the list and update its content
        int index = notes.indexWhere((note) => note.id == noteId);
        if (index != -1) {
          notes[index] = notes[index].copyWith(content: newContent);
          notes.refresh(); // This ensures that GetX updates any listeners
        }
        Get.snackbar('Success', 'Note updated successfully');
        return true;
      } else {
        Get.snackbar(
            'Error', 'Failed to update note: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating the note: $e');
      return false;
    }
  }
}
