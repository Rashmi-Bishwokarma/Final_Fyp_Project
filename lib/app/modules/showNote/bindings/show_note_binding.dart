import 'package:get/get.dart';

import '../controllers/show_note_controller.dart';

class ShowNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowNoteController>(
      () => ShowNoteController(),
    );
  }
}
