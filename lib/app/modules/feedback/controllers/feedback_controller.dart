import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/feedback.dart';

class FeedbackController extends GetxController {
  var isLoading = true.obs;
  var feedbackList = <FeedbackItem>[].obs;

  @override
  void onInit() {
    fetchFeedbacks();
    super.onInit();
  }

  void fetchFeedbacks() async {
    isLoading(true);
    var uri = Uri.http(
        ipAddress, 'rememory_api/getFeedback'); // Adjust the path as needed
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var feedbacks = jsonDecode(response.body)['feedbacks'];
        if (feedbacks != null) {
          feedbackList.value = List<FeedbackItem>.from(feedbacks
              .map((feedbackJson) => FeedbackItem.fromJson(feedbackJson)));
        } else {
          Get.snackbar('Error', 'Failed to load feedbacks');
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching feedbacks: $e');
    } finally {
      isLoading(false);
    }
  }
}
