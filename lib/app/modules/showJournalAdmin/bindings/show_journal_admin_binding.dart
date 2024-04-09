import 'package:get/get.dart';

import '../controllers/show_journal_admin_controller.dart';

class ShowJournalAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowJournalAdminController>(
      () => ShowJournalAdminController(),
    );
  }
}
