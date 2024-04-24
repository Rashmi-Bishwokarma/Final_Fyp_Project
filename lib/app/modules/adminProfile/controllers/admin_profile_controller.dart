import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp_rememory/app/models/change_password.dart';
import 'package:fyp_rememory/app/models/user.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// Your UserProfile model class

class AdminProfileController extends GetxController {
  var userResponse = Rxn<UserResponse>(); // Nullable reactive property
  var isNotificationsEnabled = false.obs;
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> feedbackFormKey = GlobalKey<FormState>();
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var feedbackController = TextEditingController();
  var rating = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

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

  Future<void> updateUserProfile({
    required String fullName,
    required String email,
    String? dateOfBirth,
    String? address,
    String? description,
    File? profileImage,
  }) async {
    Uri url = Uri.http(ipAddress,
        'rememory_api/editMyDetails'); // Adjust the path to your endpoint
    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['token'] = Memory.getToken()!
        ..fields['full_name'] = fullName
        ..fields['email'] = email
        ..fields['date_of_birth'] = dateOfBirth ?? ''
        ..fields['address'] = address ?? ''
        ..fields['description'] = description ?? '';
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
        ));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully.');
        fetchUserProfile();
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchUserProfile() async {
    Uri url = Uri.http(ipAddress, 'rememory_api/getMyDetails');
    try {
      var response = await http.post(url, body: {"token": Memory.getToken()});

      if (response.statusCode == 200) {
        final result = userResponseFromJson(response.body);
        if (result.success ?? false) {
          userResponse.value = result; // Assign the fetched response
        } else {
          Get.snackbar(
              'Error', result.message ?? 'Failed to fetch user profile');
          userResponse.value = null; // Explicitly set to null if not successful
        }
      } else {
        Get.snackbar('Server Error',
            'Failed to fetch user profile: ${response.reasonPhrase}');
        userResponse.value = null;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      userResponse.value = null;
    }
  }
}
