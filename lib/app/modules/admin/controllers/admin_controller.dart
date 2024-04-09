import 'package:flutter/material.dart';
import 'package:fyp_rememory/app/models/user.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../../dashboard/views/dashboard_view.dart';

class AdminController extends GetxController {
  UserResponse? userResponse;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  Rx<Widget> currentPage = Rx<Widget>(DashboardView()); // Default page

  void changePage(Widget newPage) {
    currentPage.value = newPage;
    update(); // Trigger a UI update
  }

  void getDetails() async {
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
}
