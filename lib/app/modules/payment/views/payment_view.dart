import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/plan.dart';
import '../controllers/payment_controller.dart'; // Adjust the import path to match your project structure
// Adjust the import path for your Plan model

class PaymentView extends StatelessWidget {
  // Assuming your PaymentController is correctly set up as before
  final PaymentController controller = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subscription Plans')),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.hasActiveSubscription.isTrue) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You already have an active subscription.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the dashboard or another relevant view
                    // Adjust the navigation based on your app structure
                    // Example: Get.offAll(() => DashboardView());
                  },
                  child: Text('Go to Dashboard'),
                ),
              ],
            ),
          );
        } else if (controller.plans.isNotEmpty) {
          return ListView.builder(
            itemCount: controller.plans.length,
            itemBuilder: (context, index) {
              final Plan plan = controller.plans[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          '${plan.price} USD - Duration: ${plan.duration} days'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            controller.initiatePayment(plan.planId),
                        child: Text('Subscribe'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No subscription plans available.'));
        }
      }),
    );
  }
}
