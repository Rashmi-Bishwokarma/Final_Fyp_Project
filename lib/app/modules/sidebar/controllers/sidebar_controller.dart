import 'package:fyp_rememory/app/models/user.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class SidebarController extends GetxController {
  UserResponse? userResponse;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getdetails();
  }

  void getdetails() async {
    try {
      Uri url = Uri.http(ipAddress, 'rememory_api/getMyDetails');

      var response = await http.post(url, body: {"token": Memory.getToken()});

      // print(response.body);

      var result = userResponseFromJson(response.body);

      if (result.success ?? false) {
        userResponse = result;
        update();
      } else {
        showCustomSnackBar(
          message: result.message ?? '',
        );
      }
    } catch (e) {
      showCustomSnackBar(
        message: e.toString(),
      );
    }
  }
}
