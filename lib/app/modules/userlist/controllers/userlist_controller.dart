import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/all_users.dart';

class UserListController extends GetxController {
  var isLoading = false.obs;
  var userList = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    isLoading(true);
    var client = http.Client();
    try {
      // Replace with your actual endpoint URL
      var uri = Uri.http(ipAddress, 'rememory_api/allUsers');
      var response = await client.get(uri);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        // Assuming the JSON structure directly maps to your UsersList model
        UsersList usersList = UsersList.fromJson(jsonData);
        userList.assignAll(usersList.users);
      } else {
        Get.snackbar('Error',
            'Failed to load users with status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching users: $e');
    } finally {
      isLoading(false);
      client.close();
    }
  }
}
