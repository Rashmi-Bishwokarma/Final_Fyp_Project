import 'dart:convert';
import 'package:fyp_rememory/app/routes/app_pages.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final count = 0.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  var identifierController = TextEditingController(); // Updated controller name
  var passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs; // Tracks if password is visible

  void togglePasswordVisibility() {
    isPasswordVisible.toggle(); // Toggle the visibility state
  }

  void increment() {
    count.value++;
  }

  void onLogin() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        var url = Uri.http(ipAddress, 'rememory_api/auth/login.php');

        var response = await http.post(url, body: {
          'identifier': identifierController.text, // Updated field name
          'password': passwordController.text,
        });

        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);

          if (result['success']) {
            showCustomSnackBar(
              message: result['message'],
              isSuccess: true,
            );
            Memory.setToken(result['token']);
            Memory.setRole(result['role']);

            var role = Memory.getRole();

            if (role == 'admin') {
              Get.offAllNamed(Routes.ADMIN);
            } else if (role == 'user') {
              Get.offAllNamed(Routes.USER_HOME);
            } else {
              print('Unknown Role: $role');
            }
          } else {
            showCustomSnackBar(
              message: result['message'],
            );
          }
        } else {
          showCustomSnackBar(
            message: 'An error occurred during login. Please try again.',
          );
          print('HTTP Error Status Code: ${response.statusCode}');
        }
      } catch (e) {
        showCustomSnackBar(
          message: 'An error occurred during login. Please try again.',
        );
        print('Error during login API call: $e');
      }
    }
  }
}
