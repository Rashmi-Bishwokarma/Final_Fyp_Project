// controllers/show_journal_controller.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_rememory/app/models/journal.dart'; // Make sure the path is correct
import 'package:fyp_rememory/app/utils/memory.dart';

class ShowJournalController extends GetxController {
  var isLoading = RxBool(false);
  var journalEntries = RxList<Journal>([]);
  var searchQuery = ''.obs; // To hold the search query

  // Call this method when the search query changes.
  void onSearchTextChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      fetchJournalEntries(); // Reload all entries if search is cleared
    } else {
      filterJournalEntries(query.toLowerCase());
    }
  }

  // This method filters the journal entries based on the search query.
  void filterJournalEntries(String query) {
    var filteredEntries = journalEntries.where((entry) {
      // Add more conditions if you want to search in other fields like `tags`.
      return entry.title!.toLowerCase().contains(query) ||
          entry.entry!.toLowerCase().contains(query);
    }).toList();

    journalEntries.assignAll(filteredEntries); // Update the list of entries
  }

  @override
  void onInit() {
    super.onInit();
    fetchJournalEntries();
  }

  Future<void> editJournalEntry({
    required String journalId,
    required String title,
    required String entry,
    String? location,
    String? mood,
    String? featuredImage,
  }) async {
    Uri url = Uri.http(ipAddress,
        'rememory_api/editJournal'); // Adjust with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory
              .getToken(), // Assuming you're using a token for authentication
          'journal_id':
              journalId, // Journal ID to identify which journal entry to edit
          'title': title,
          'entry': entry,
          'location':
              location ?? '', // Optional field, send empty string if null
          'mood': mood ?? '', // Optional field, send empty string if null
          'featured_image':
              featuredImage ?? '', // Optional field, send empty string if null
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        if (kDebugMode) {
          print('Journal entry edited successfully');
        }
        fetchJournalEntries(); // Refresh the journal list to show the updated entry
      } else {
        if (kDebugMode) {
          print('Failed to edit journal entry: ${responseData['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error editing journal entry: $e');
      }
    }
  }

  Future<void> deleteJournalEntry(String journalId) async {
    isLoading(true); // Show loading indicator
    Uri url = Uri.http(ipAddress,
        'rememory_api/deleteJournal.php'); // Adjust with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory
              .getToken(), // Assuming Memory.getToken() retrieves the stored token
          'journal_id': journalId,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        // Successfully deleted on the server, now remove from local list

        journalEntries.removeWhere((journal) => journal.id == journalId);
        Get.snackbar('Success', 'Journal entry deleted successfully');
        update(); // Notify listeners to update the UI
      } else {
        Get.snackbar('Error',
            'Failed to delete journal entry: ${responseData['message']}');
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'An error occurred while deleting the journal entry: $e');
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }

  Future<bool> deleteEntry(String journalId) async {
    isLoading(true); // Show loading indicator
    Uri url = Uri.http(ipAddress,
        'rememory_api/deleteJournal'); // Adjust with your actual API endpoint
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory
              .getToken(), // Assuming Memory.getToken() retrieves the stored token
          'journal_id': journalId,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        // Successfully deleted on the server, now remove from local list
        journalEntries.removeWhere((entry) => entry.id.toString() == journalId);
        Get.snackbar('Success', 'Journal entry deleted successfully');
        return true;
      } else {
        Get.snackbar('Error',
            'Failed to delete journal entry: ${responseData['message']}');
        return false;
      }
    } catch (e) {
      Get.snackbar(
          'Error', 'An error occurred while deleting the journal entry: $e');
      return false;
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }

  void sortJournalEntries() {
    journalEntries.sort((Journal a, Journal b) {
      DateTime aDate = a.createdAt ?? DateTime.now();
      DateTime bDate = b.createdAt ?? DateTime.now();
      return bDate.compareTo(aDate); // For descending order
    });
  }

  // Call this method when adding a new journal entry to ensure the list is sorted.
  void addJournalEntry(Journal newEntry) {
    journalEntries.add(newEntry);
    sortJournalEntries();
  }

  Future<void> fetchJournalEntries() async {
    Uri url = Uri.http(ipAddress,
        'rememory_api/getJournal'); // Adjust with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory.getToken(),
        },
      );

      if (response.statusCode == 200) {
        final journalResponse = journalResponseFromJson(response.body);
        if (journalResponse.success == true &&
            journalResponse.journal != null) {
          journalEntries.assignAll(journalResponse.journal!);
          // Or you could use:
          // journalEntries.value = journalResponse.journal!;
          sortJournalEntries();
          isLoading(false);
          // Ensure you're setting this to false after fetching
        } else {
          Get.snackbar('Error', 'Failed to fetch journal entries');
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Error',
            'Failed to fetch journal entries: ${response.reasonPhrase}');
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void editEntry(Journal entry) {}
}
