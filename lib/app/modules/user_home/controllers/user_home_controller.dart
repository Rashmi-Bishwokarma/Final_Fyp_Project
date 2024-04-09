import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:fyp_rememory/app/models/user.dart';

class UserHomeController extends GetxController {
  UserResponse? userResponse;
  final TextEditingController noteContentController =
      TextEditingController(); // Rename it here
  GlobalKey<FormState> noteFormKey = GlobalKey<FormState>();
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthentication();
  }

  void checkAuthentication() async {
    try {
      Uri url = Uri.http(ipAddress, 'rememory_api/getMyDetails');
      var response = await http.post(url, body: {"token": Memory.getToken()});

      if (response.statusCode == 200) {
        var result = userResponseFromJson(response.body);

        if (result.success ?? false) {
          userResponse = result;
          update();
        } else {
          showCustomSnackBar(
            message: result.message ?? '',
          );
        }
      } else {
        showCustomSnackBar(
          message:
              'Failed to fetch details. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: 'An error occurred: $e',
      );
    }
  }

  Future<void> submitNote() async {
    if (noteFormKey.currentState!.validate()) {
      Uri uri = Uri.http(
          ipAddress, 'rememory_api/addNote'); // Adjust endpoint as necessary

      try {
        var response = await http.post(
          uri,
          body: {
            'token': Memory
                .getToken(), // Assuming Memory.getToken() returns the correct token
            'content': noteContentController.text, // Note content
          },
        );

        var responseData = json.decode(response.body);
        if (responseData['success']) {
          Get.back();
          Get.snackbar(
            'Success',
            'Note added successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to add note.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred while submitting: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
