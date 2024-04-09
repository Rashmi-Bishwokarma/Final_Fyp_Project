import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fyp_rememory/app/models/change_password.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart'; // Make sure this import is correct
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SettingsController extends GetxController {
  var isNotificationsEnabled = false.obs;
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> feedbackFormKey = GlobalKey<FormState>();
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var feedbackController = TextEditingController();
  var rating = 0.obs; // Assuming rating is an integer value

  // Method to toggle notification setting
  void toggleNotifications(bool value) {
    isNotificationsEnabled(value);
  }

  // Method to change password using the API
  Future<void> changePassword() async {
    if (changePasswordFormKey.currentState!.validate()) {
      var url = Uri.http(ipAddress, 'rememory_api/change_password.php');
      final token = Memory.getToken(); // Retrieve the token from Memory

      try {
        final response = await http.post(url, body: {
          'token': token,
          'old_password': oldPasswordController.text,
          'new_password': newPasswordController.text,
        });

        final changePasswordResponse = changePasswordFromJson(response.body);

        if (changePasswordResponse.success == true) {
          Get.snackbar(
              'Success',
              changePasswordResponse.message ??
                  'Password changed successfully!');
          // Perform additional actions on success, if needed
        } else {
          Get.snackbar('Error',
              changePasswordResponse.message ?? 'Error changing password');
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred while changing the password.');
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> submitFeedback() async {
    if (feedbackFormKey.currentState!.validate()) {
      var url = Uri.http(ipAddress, 'rememory_api/addFeedback.php');
      final token = Memory.getToken(); // Retrieve the token from Memory

      try {
        final response = await http.post(url, body: {
          'token': token,
          'message': feedbackController.text,
          'rating': rating.toString(),
        });

        final result = jsonDecode(response.body);
        if (result['success']) {
          Get.snackbar('Success', 'Feedback submitted successfully!');
          // Resetting the form and controllers after successful submission
          feedbackFormKey.currentState!.reset();
          feedbackController.clear();
          rating.value = 0; // Reset rating to initial value if applicable
        } else {
          Get.snackbar('Error', result['message']);
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred while submitting feedback.');
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  // ... Rest of your code
}
