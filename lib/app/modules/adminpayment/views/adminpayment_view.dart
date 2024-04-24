import 'package:flutter/material.dart';
import 'package:fyp_rememory/app/models/list_payment.dart';

import 'package:get/get.dart';

import '../controllers/adminpayment_controller.dart';

class AdminpaymentView extends GetView<AdminpaymentController> {
  const AdminpaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AdminpaymentController());
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 254,
              255), // Applies a 5 pixels radius uniformly to all corners
        ),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 252, 254, 255),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 252, 254, 255),
            title: const Text('Payment Details'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Obx(() {
              if (controller.isLoading.isTrue) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('User ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Plan')),
                      DataColumn(label: Text('Start Date')),
                      DataColumn(label: Text('End Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Duration')),

                      // Add more DataColumn for additional fields
                    ],
                    rows: controller.subscriptionsList
                        .map((subscription) => _buildDataRow(subscription))
                        .toList(),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}

DataRow _buildDataRow(Subscription subscription) {
  return DataRow(cells: [
    DataCell(Text(subscription.subscriptionId)),
    DataCell(Text(subscription.userId)),
    DataCell(Text(subscription.fullName)),
    DataCell(Text(subscription.email)),
    DataCell(Text(subscription.planName)),
    DataCell(Text(subscription.startDate)),
    DataCell(Text(subscription.endDate)),
    DataCell(Text(subscription.status)),
    DataCell(Text(subscription.price)),
    DataCell(Text(subscription.duration)),

    // Add more cells for additional fields
  ]);
}
