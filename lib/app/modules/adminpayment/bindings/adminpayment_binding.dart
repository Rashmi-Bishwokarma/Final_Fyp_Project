import 'package:get/get.dart';

import '../controllers/adminpayment_controller.dart';

class AdminpaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminpaymentController>(
      () => AdminpaymentController(),
    );
  }
}
