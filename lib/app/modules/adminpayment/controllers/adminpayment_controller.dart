import 'dart:convert';

import 'package:fyp_rememory/app/models/list_payment.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class AdminpaymentController extends GetxController {
  var isLoading = false.obs;
  var subscriptionsList = <Subscription>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  void fetchSubscriptions() async {
    isLoading(true);
    try {
      // Replace with your API endpoint
      Uri url = Uri.http(ipAddress,
          'rememory_api/adminPayment'); // Replace with your actual URL
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final subscriptionJsonList =
            json.decode(response.body)['subscription_list'] as List;
        final fetchedSubscriptions = subscriptionJsonList
            .map((json) => Subscription.fromJson(json))
            .toList();
        subscriptionsList.assignAll(fetchedSubscriptions);
      } else {
        Get.snackbar('Error', 'Failed to fetch data from the server');
      }
    } finally {
      isLoading(false);
    }
  }
}
