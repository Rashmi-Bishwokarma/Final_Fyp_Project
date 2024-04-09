import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class EditJournalController extends GetxController {
  late TextEditingController subjectController;
  late TextEditingController locationController;
  late TextEditingController entryController;
  var mood = ''.obs;
  var privacy = 'private'.obs;
  var journalFormKey = GlobalKey<FormState>();
  var selectedImage = Rxn<File>();

  EditJournalController() {
    subjectController = TextEditingController();
    locationController = TextEditingController();
    entryController = TextEditingController();
  }
  void setPrivacy(String newPrivacy) {
    if (newPrivacy == 'public' || newPrivacy == 'private') {
      privacy.value = newPrivacy;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final journalId = Get.arguments['journalId'];
    if (journalId != null) {
      fetchJournalData(journalId.toString());
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    locationController.dispose();
    entryController.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void setMood(String newMood) {
    mood.value = newMood;
  }

  Future<Map<String, dynamic>> getJournalData(String journalId) async {
    final Uri url = Uri.http(
        ipAddress, 'rememory_api/getJournal', {'journalId': journalId});
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        if (kDebugMode) {
          print("Failed to fetch journal data: ${response.body}");
        }
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching journal data: $e");
      }
      return {};
    }
  }

  void fetchJournalData(String journalId) async {
    var responseData = await getJournalData(journalId);

    subjectController.text = responseData['title'] ?? '';
    locationController.text = responseData['location'] ?? '';
    entryController.text = responseData['entry'] ?? '';
    mood.value = responseData['mood'] ?? '';
    // Handle the image if it's part of the responseData
  }

  Future<void> editJournalEntry(String journalId) async {
    if (journalFormKey.currentState!.validate()) {
      Uri uri = Uri.http(ipAddress, 'rememory_api/editJournal');
      var request = http.MultipartRequest('POST', uri)
        ..fields['token'] = Memory.getToken()!
        ..fields['journal_id'] = journalId
        ..fields['title'] = subjectController.text
        ..fields['entry'] = entryController.text
        ..fields['location'] = locationController.text
        ..fields['mood'] = mood.value
        ..fields['privacy'] = privacy.value;

      if (selectedImage.value != null) {
        String fileName = selectedImage.value!.path.split('/').last;
        request.files.add(http.MultipartFile(
          'featured_image',
          selectedImage.value!.readAsBytes().asStream(),
          selectedImage.value!.lengthSync(),
          filename: fileName,
          contentType: MediaType('image', fileName.split('.').last),
        ));
      }

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }

        if (response.statusCode == 200) {
          json.decode(response.body);
          // Handle the response data if needed
        } else {
          if (kDebugMode) {
            print(
                'The server responded with status code: ${response.statusCode}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Journal ID: $journalId");
        }
        if (kDebugMode) {
          print('Exception caught: $e');
        }
        Get.snackbar('Error', 'An error occurred while updating.');
      }
    }
  }
}
