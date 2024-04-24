import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/plan.dart';
import '../controllers/payment_controller.dart';
// Adjust the import path to match your project structure
// Adjust the import path for your Plan model

class PaymentView extends GetView<PaymentController> {
  // Assuming your PaymentController is correctly set up as before

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PaymentController());
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Subscription Plans',
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      )),
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
                      Text(
                        plan.name,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' Rs ${plan.price}  - Duration: ${plan.duration} days',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            controller.makeSubscriptionPayment(plan),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icon/KhaltiLogo-removebg-preview.png', // Update this path to where your asset is located
                              width: 80,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Pay with Khalti',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF473A79),
                              ),
                            )
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 203, 195, 195)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No subscription plans available.'));
        }
      }),
    );
  }
}

const khaltiLogo =
    "https://play-lh.googleusercontent.com/Xh_OlrdkF1UnGCnMN__4z-yXffBAEl0eUDeVDPr4UthOERV4Fll9S-TozSfnlXDFzw";
