import 'dart:convert';

import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var fullNameController = TextEditingController();

  var registerFormKey = GlobalKey<FormState>();

  final count = 0.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  @override
  void onInit() {
    // Called on controller initialization
    Get.lazyPut(() => RegisterController());
    super.onInit();
  }

  void onRegister() async {
    if (registerFormKey.currentState!.validate()) {
      try {
        var url = Uri.http(ipAddress, 'rememory_api/auth/register');

        var response = await http.post(url, body: {
          'fullname': fullNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        });

        var result = jsonDecode(response.body);

        if (result['success']) {
          Get.back();
          showCustomSnackBar(
            message: result['message'],
            isSuccess: true,
          );
        } else {
          showCustomSnackBar(
            message: result['message'],
          );
        }
      } catch (e) {
        showCustomSnackBar(
          message: 'Something went wrong',
        );
      }
    }
  }

  void increment() => count.value++;
}
