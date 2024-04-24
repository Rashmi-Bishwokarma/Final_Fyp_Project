import 'dart:convert';
import 'dart:io';

import 'package:fyp_rememory/app/modules/payment/views/payment_view.dart';
import 'package:fyp_rememory/app/utils/constants.dart';
import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

// Define your custom TextEditingController to handle hashtag styling
class RichTextEditingController extends TextEditingController {
  final TextStyle normalStyle;
  final TextStyle hashtagStyle;

  RichTextEditingController({
    required this.normalStyle,
    required this.hashtagStyle,
  });

  // Override buildTextSpan to style text within the controller
  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    List<TextSpan> spans = [];
    text.splitMapJoin(
      RegExp(r'(\s+)'), // Split based on whitespace
      onMatch: (m) {
        // For matches of whitespace, add it back to the text
        spans.add(TextSpan(text: m[0], style: normalStyle));
        return m[0]!;
      },
      onNonMatch: (word) {
        // For non-matches, style hashtags differently
        final isHashtag = word.startsWith('#') && word.length > 1;
        spans.add(TextSpan(
          text: word,
          style: isHashtag ? hashtagStyle : normalStyle,
        ));
        return word;
      },
    );
    return TextSpan(children: spans);
  }
}

// Your main controller for the journal logic
class JournalController extends GetxController {
  late RichTextEditingController entryController;
  var subjectController = TextEditingController();
  var locationController = TextEditingController();
  var mood = ''.obs;
  var privacy = 'private'.obs;
  var journalFormKey = GlobalKey<FormState>();
  var selectedImage = Rxn<File>();
  var hasActiveSubscription = false.obs;
  var isLoading = RxBool(false);

  JournalController() {
    entryController = RichTextEditingController(
      normalStyle: const TextStyle(color: Colors.black),
      hashtagStyle: const TextStyle(color: Colors.blue),
    );
  }

  @override
  void onClose() {
    subjectController.dispose();
    locationController.dispose();

    entryController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
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

  Future<void> checkSubscriptionStatus() async {
    isLoading(true);
    try {
      Uri uri = Uri.http(ipAddress, 'rememory_api/check_subscription');
      var response = await http.post(
        uri,
        body: {
          'token': Memory.getToken(),
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        hasActiveSubscription.value = responseData['hasActiveSubscription'];

        if (!hasActiveSubscription.value) {
          // Redirect to PaymentView if no active subscription
        } else {
          // Proceed to fetch journals if subscription is active
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> setPrivacy(String newPrivacy) async {
    // Check if the user wants to make the post public
    if (newPrivacy == 'public') {
      // First, ensure the current subscription status is updated
      await checkSubscriptionStatus();
      // Then, check if the user has an active subscription
      if (!hasActiveSubscription.value) {
        // If not, show a dialog to inform the user they need a subscription to proceed
        Get.dialog(
          AlertDialog(
            title: Text('Subscription Required'),
            content:
                Text('You need an active subscription to make posts public.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Get.back(), // Close the dialog
              ),
              TextButton(
                child: Text('Subscribe'),
                onPressed: () {
                  Get.back(); // Close the dialog
                  // Navigate to the subscription page
                  Get.to(() => PaymentView());
                },
              ),
            ],
          ),
        );
        return; // Exit the method to prevent setting privacy to public without a subscription
      }
    }
    // If making the post private or if the user has an active subscription, proceed as normal
    privacy.value = newPrivacy;
  }

  Future<void> submitJournalEntry() async {
    if (journalFormKey.currentState!.validate()) {
      Uri uri = Uri.http(ipAddress, 'rememory_api/addJournal');
      var request = http.MultipartRequest('POST', uri)
        ..fields['token'] = Memory.getToken()! // Replace with actual token
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

        var responseData = json.decode(response.body);
        if (responseData['success']) {
          Get.back();
          Get.snackbar(
            'Success',
            'Journal entry added successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to add journal entry.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred while submitting.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
