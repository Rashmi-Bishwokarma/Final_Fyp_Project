import 'package:get/get.dart';

import '../controllers/notify_controller.dart';

class NotifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotifyController>(
      () => NotifyController(),
    );
  }
}
