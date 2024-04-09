import 'package:get/get.dart';

import '../controllers/showjournal_controller.dart';

class ShowjournalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowJournalController>(
      () => ShowJournalController(),
    );
  }
}
