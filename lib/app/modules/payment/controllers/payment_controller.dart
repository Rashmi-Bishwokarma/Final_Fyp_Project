import 'package:fyp_rememory/app/models/plan.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:khalti_flutter/khalti_flutter.dart';

// Ensure you have a Plan model based on the previous example

class PaymentController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var hasActiveSubscription = false.obs;
  var plans = <Plan>[].obs;
  // Ideally fetched securely from user session or storage
  Rx<Plan> selectedPlan = Rx<Plan>(Plan(
    planId: '', // Default values
    name: '',
    price: '0',
    duration: '',
    features: '',
    isActive: '',
  ));

  // Call this method when the user selects a plan
  void selectPlan(Plan plan) {
    selectedPlan.value = plan;
  }

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

  void makeSubscriptionPayment(Plan plan) {
    try {
      // Parse the amount string to a double and convert to the smallest currency unit
      double amount = double.parse(plan.price);
      int amountInPaisa = (amount * 100).round(); // Convert to paisa for Khalti

      PaymentConfig config = PaymentConfig(
        productName: "Subscription - ${plan.name}",
        amount: amountInPaisa,
        productIdentity: plan.planId,
      );

      KhaltiScope.of(Get.context!).pay(
        config: config,
        preferences: [PaymentPreference.khalti],
        onSuccess: (v) async {
          Uri url = Uri.http(ipAddress, 'rememory_api/payment');
          var response = await http.post(url, body: {
            'token': Memory.getToken() ?? '',
            'plan_id': plan.planId,
            'amount': plan
                .price, // You might want to send amountInPaisa depending on backend
            // Make sure to serialize the response correctly
          });

          var result = jsonDecode(response.body);

          if (result['success']) {
            showCustomSnackBar(
              message: 'Subscription successful',
              isSuccess: true,
            );
            // Perform actions after successful subscription, like navigation or updating the UI
          } else {
            showCustomSnackBar(message: result['message']);
          }
        },
        onFailure: (v) {
          showCustomSnackBar(message: v.message);
        },
      );
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }
}
