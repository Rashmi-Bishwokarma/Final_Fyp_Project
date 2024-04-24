import 'package:fyp_rememory/app/models/count.dart';
import 'package:fyp_rememory/app/models/rating.dart';
import 'package:fyp_rememory/app/models/total_revenue.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardController extends GetxController {
  var isLoading = true.obs;
  Rx<TableCounts> tableCounts = TableCounts(
    comments: 0,
    feedback: 0,
    journals: 0,
    journalTags: 0,
    likes: 0,
    notes: 0,
    notifications: 0,
    payments: 0,
    personalAccessToken: 0,
    plans: 0,
    subscriptions: 0,
    tags: 0,
    tasks: 0,
    users: 0,
  ).obs;
  RxList<JournalCount> journalCounts = RxList<JournalCount>();
  var averageRating = AverageRating(averageRating: 0.0).obs;
  var totalRevenue = TotalRevenue(totalRevenue: 0.0).obs;
  var salesGoal = 10000.0;
  @override
  void onInit() {
    super.onInit();
    fetchAverageRating();
    fetchTotalRevenue();
    fetchData();
  }

  Future<void> fetchAverageRating() async {
    try {
      Uri url = Uri.http(ipAddress, 'rememory_api/rating.php');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Now we use the model to parse the JSON.
        AverageRating ratingData = AverageRating.fromJson(data);
        // And we assign the model to the observable variable.
        averageRating.value = ratingData;
      } else {
        throw Exception('Failed to load average rating');
      }
    } catch (e) {
      print('An error occurred: $e');
      // Handle exceptions by showing an error message or a default value
    }
  }

  void fetchTotalRevenue() async {
    try {
      Uri url = Uri.http(ipAddress, 'rememory_api/totalMoney.php');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        totalRevenue.value = TotalRevenue.fromJson(data);
      } else {
        throw Exception('Failed to load total revenue');
      }
    } catch (e) {
      print('An error occurred while fetching total revenue: $e');
      // Handle exceptions by showing an error message or setting a default value
    }
  }

  void fetchData() async {
    isLoading(true);
    try {
      tableCounts.value = await fetchTableCounts();
      journalCounts.assignAll(await fetchJournalCounts());
    } catch (e) {
      // Handle exceptions here, for example logging them or displaying an error message
      print('An error occurred while fetching data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<TableCounts> fetchTableCounts() async {
    Uri url = Uri.http(ipAddress, 'rememory_api/count');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return TableCounts.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load table counts. Status Code: ${response.statusCode}');
    }
  }

  Future<List<JournalCount>> fetchJournalCounts() async {
    Uri url = Uri.http(ipAddress,
        'rememory_api/getJournalCount'); // Replace with your actual URL
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey('journal_counts')) {
        List<dynamic> data = decodedResponse['journal_counts'];
        return data.map((e) => JournalCount.fromJson(e)).toList();
      } else {
        throw Exception(
            'The expected "journal_counts" key was not found in the response.');
      }
    } else {
      throw Exception(
          'Failed to load journal counts. Status Code: ${response.statusCode}');
    }
  }

  averageJournalCount() {}
}
