import 'package:fyp_rememory/app/models/plan.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Ensure you have a Plan model based on the previous example

class PaymentController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var hasActiveSubscription = false.obs;
  var plans = <Plan>[].obs;
  // Ideally fetched securely from user session or storage

  @override
  void onInit() {
    super.onInit();
    checkSubscriptionStatusAndFetchPlans();
  }

  void checkSubscriptionStatusAndFetchPlans() async {
    isLoading(true);
    await checkSubscriptionStatus();
    if (!hasActiveSubscription.value) {
      await fetchPlans();
    }
    isLoading(false);
  }

  Future<void> checkSubscriptionStatus() async {
    var uri = Uri.http(ipAddress, 'rememory_api/check_subscription');
    try {
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Memory.getToken()}',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        hasActiveSubscription.value = data['hasActiveSubscription'];
      } else {
        print('Failed to check subscription status');
      }
    } catch (e) {
      print('Error checking subscription status: $e');
    }
  }

  Future<void> fetchPlans() async {
    var uri = Uri.http(ipAddress, 'rememory_api/getPlan');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success']) {
          var fetchedPlans =
              List<Plan>.from(data['plans'].map((plan) => Plan.fromJson(plan)));
          plans.assignAll(fetchedPlans);
        } else {
          print('No plans found');
        }
      } else {
        print('Failed to fetch plans');
      }
    } catch (e) {
      print('Error fetching plans: $e');
    }
  }

  Future<void> initiatePayment(String planId) async {}
}
