import 'package:get/get.dart';

import '../controllers/userlist_controller.dart';

class UserlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserListController>(
      () => UserListController(),
    );
  }
}
