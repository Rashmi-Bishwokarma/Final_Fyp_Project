import 'dart:io';

import 'package:fyp_rememory/app/models/user.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// Your UserProfile model class

class ProfileController extends GetxController {
  var userResponse = Rxn<UserResponse>(); // Nullable reactive property

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String email,
    String? dateOfBirth,
    String? address,
    String? description,
    File? profileImage,
  }) async {
    Uri url = Uri.http(ipAddress,
        'rememory_api/editMyDetails'); // Adjust the path to your endpoint
    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['token'] = Memory.getToken()!
        ..fields['full_name'] = fullName
        ..fields['email'] = email
        ..fields['date_of_birth'] = dateOfBirth ?? ''
        ..fields['address'] = address ?? ''
        ..fields['description'] = description ?? '';
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
        ));
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully.');
        fetchUserProfile();
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void fetchUserProfile() async {
    Uri url = Uri.http(ipAddress, 'rememory_api/getMyDetails');
    try {
      var response = await http.post(url, body: {"token": Memory.getToken()});

      if (response.statusCode == 200) {
        final result = userResponseFromJson(response.body);
        if (result.success ?? false) {
          userResponse.value = result; // Assign the fetched response
        } else {
          Get.snackbar(
              'Error', result.message ?? 'Failed to fetch user profile');
          userResponse.value = null; // Explicitly set to null if not successful
        }
      } else {
        Get.snackbar('Server Error',
            'Failed to fetch user profile: ${response.reasonPhrase}');
        userResponse.value = null;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      userResponse.value = null;
    }
  }
}
