import 'package:flutter/foundation.dart';
import 'package:fyp_rememory/app/models/plan.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlansController extends GetxController {
  var isLoading = false.obs;
  var plansList = <Plan>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    isLoading(true);
    try {
      Uri url = Uri.http(
          ipAddress, 'rememory_api/getPlan'); // Replace with your actual URL
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body)['plans'];
        plansList.value = jsonData.map((json) => Plan.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch plans');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching plans');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addPlan(Plan plan) async {
    isLoading(true);
    try {
      Uri url = Uri.http(ipAddress, 'rememory_api/addPlan');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': Memory.getToken(), // Assuming token-based authentication
          'name': plan.name,
          'price': plan.price,
          'duration': plan.duration,
          'features': plan.features,
          'isActive': plan.isActive,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        if (kDebugMode) {
          print('Plan added successfully');
        }
        fetchPlans(); // Assuming a method to fetch all plans
      } else {
        if (kDebugMode) {
          print('Failed to add plan: ${responseData['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding plan: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updatePlan(Plan plan) async {
    isLoading(true);
    try {
      Uri url = Uri.http(ipAddress, 'rememory_api/updatePlan');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': Memory.getToken(), // Assuming token-based authentication
          'planId': plan.planId,
          'name': plan.name,
          'price': plan.price,
          'duration': plan.duration,
          'features': plan.features,
          'isActive': plan.isActive,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        if (kDebugMode) {
          print('Plan updated successfully');
        }
        fetchPlans(); // Refresh the list
      } else {
        if (kDebugMode) {
          print('Failed to update plan: ${responseData['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating plan: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletePlan(String planId) async {
    isLoading(true);
    Uri url = Uri.http(ipAddress,
        'rememory_api/deletePlan'); // Adjust with your actual API endpoint

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': Memory.getToken(),
          'id': planId,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        if (kDebugMode) {
          print('Plan deleted successfully');
        }
        fetchPlans(); // Refresh the list
      } else {
        if (kDebugMode) {
          print('Failed to delete plan: ${responseData['message']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting plan: $e');
      }
    } finally {
      isLoading(false);
    }
  }
}
