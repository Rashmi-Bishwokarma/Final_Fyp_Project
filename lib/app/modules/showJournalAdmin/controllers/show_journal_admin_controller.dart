import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fyp_rememory/app/models/explore_post.dart'; // Adjust your import path accordingly
import '../../../utils/constants.dart';

class ShowJournalAdminController extends GetxController {
  var isLoading = RxBool(false);
  RxList<Journal> journalEntries = RxList<Journal>();
  var searchQuery = ''.obs;
  var isLiked = false.obs; // Make isLiked observable
  var likeCount = 0.obs;

  void onSearchTextChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      fetchJournals(); // Reload all entries if search is cleared
    } else {
      filterJournalEntries(query.toLowerCase());
    }
  }

  void sortJournalEntries() {
    journalEntries.sort((Journal a, Journal b) {
      DateTime aDate = a.createdAt;
      DateTime bDate = b.createdAt;
      return bDate.compareTo(aDate); // For descending order
    });
  }

  // This method filters the journal entries based on the search query.
  void filterJournalEntries(String query) {
    var filteredEntries = journalEntries.where((entry) {
      // Add more conditions if you want to search in other fields like `tags`.
      return entry.fullName.toLowerCase().contains(query) ||
          entry.title.toLowerCase().contains(query) ||
          entry.entry.toLowerCase().contains(query);
    }).toList();

    journalEntries.assignAll(filteredEntries); // Update the list of entries
  }

  @override
  void onInit() {
    super.onInit();
    fetchJournals();
  }

  void fetchJournals() async {
    isLoading(true);
    try {
      Uri uri = Uri.http(ipAddress, 'rememory_api/explore.php');
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        journalEntries.value =
            data.map((json) => Journal.fromJson(json)).toList();
      }
    } catch (e) {
      print(e); // Handle error
    } finally {
      isLoading(false);
    }
  }

  void toggleLike(int journalId) async {
    isLoading(true);
    try {
      Uri uri = Uri.http(ipAddress, 'rememory_api/likeJournal.php');
      var response = await http.post(
        uri,
        body: {
          'journal_id': journalId.toString(),
          'token': Memory
              .getToken(), // You need to replace `userToken` with your actual token variable
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['success']) {
          fetchJournals(); // Re-fetch the journals to reflect the like status correctly
        } else {
          // Handle unsuccessful request (e.g., authentication failure)
          print(responseData['message']);
        }
      } else {
        // Handle HTTP error
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print(e); // Handle error in request
    } finally {
      isLoading(false);
    }
  }
}
