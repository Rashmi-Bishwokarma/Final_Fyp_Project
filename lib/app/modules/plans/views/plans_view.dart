import 'package:flutter/material.dart';
import 'package:fyp_rememory/app/models/plan.dart';

import 'package:get/get.dart';

import '../controllers/plans_controller.dart';

class PlansView extends GetView<PlansController> {
  const PlansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PlansController());
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 254, 255),
          borderRadius: BorderRadius.circular(
              8), // Applies a 5 pixels radius uniformly to all corners
        ),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 252, 254, 255),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 252, 254, 255),
            title: const Text('Plan Details'),
            centerTitle: true,
          ),
          body: Obx(() {
            if (controller.isLoading.isTrue) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: controller.plansList
                  .map((plan) => Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(plan.name),
                          subtitle:
                              Text('${plan.features} - \Rs ${plan.price}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    showEditAddPlanDialog(plan: plan),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    controller.deletePlan(plan.planId),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showEditAddPlanDialog(),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

void showEditAddPlanDialog({Plan? plan}) {
  final isNew = plan == null;
  final PlansController controller = Get.find();
  final TextEditingController nameController =
      TextEditingController(text: isNew ? '' : plan!.name);
  final TextEditingController priceController =
      TextEditingController(text: isNew ? '' : plan!.price);
  final TextEditingController featuresController =
      TextEditingController(text: isNew ? '' : plan!.features);

  Get.dialog(
    AlertDialog(
      title: Text(isNew ? 'Add Plan' : 'Edit Plan'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: featuresController,
              decoration: const InputDecoration(labelText: 'Features'),
            ),
            // Add more fields as needed
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (isNew) {
              controller.addPlan(
                Plan(
                  name: nameController.text,
                  price: priceController.text,
                  features: featuresController.text, planId: '', duration: '',
                  isActive: '',
                  // Assign other fields as needed
                ),
              );
            } else {
              plan!.name = nameController.text;
              plan.price = priceController.text;
              plan.features = featuresController.text;
              // Update other fields as needed
              controller.updatePlan(plan);
            }
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
