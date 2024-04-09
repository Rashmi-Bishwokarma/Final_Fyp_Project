import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// For File

// Adjust import paths as needed
import '../controllers/journal_controller.dart';
import 'package:fyp_rememory/app/components/emoji_dropdown.dart';

class JournalView extends GetView<JournalController> {
  const JournalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => JournalController());
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Show the exit confirmation dialog
        final shouldPop = await showExitConfirmationDialog(context);
        return shouldPop ?? false; // Return false if null
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 239, 239),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 240, 239, 239),
            elevation: 2,
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (controller.journalFormKey.currentState!.validate()) {
                    controller.submitJournalEntry();
                  }
                },
              ),
            ],
            title: const Text('Create Post'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.journalFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Obx(
                    () => SwitchListTile(
                      title: const Text('Privacy'),
                      subtitle: const Text('Make entry public?'),
                      value: controller.privacy.value == 'public',
                      onChanged: (bool value) async {
                        await controller
                            .setPrivacy(value ? 'public' : 'private');
                      },
                    ),
                  ),
                  TextFormField(
                    controller: controller.subjectController,
                    decoration: const InputDecoration(
                      hintText: 'Subject',
                      prefixIcon: Icon(Icons.subject),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  EmojiDropdown(
                    onMoodChanged: (selectedMood) {
                      controller.setMood(selectedMood);
                    },
                  ),
                  const SizedBox(height: 20),
// Add privacy toggle

                  const SizedBox(height: 10),
                  TextFormField(
                    controller: controller.locationController,
                    decoration: const InputDecoration(
                      hintText: 'Location',
                      prefixIcon: Icon(Icons.location_on),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Photo Library'),
                                    onTap: () {
                                      controller.pickImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    controller.pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Obx(() => Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            image: controller.selectedImage.value != null
                                ? DecorationImage(
                                    image: FileImage(
                                        controller.selectedImage.value!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ), // Show icon if no image selected
                          alignment: Alignment.center,
                          child: controller.selectedImage.value == null
                              ? const Icon(Icons.camera_alt,
                                  color: Color.fromARGB(255, 207, 206, 206),
                                  size: 50)
                              : null,
                        )),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.entryController,
                    decoration: const InputDecoration(
                      hintText: 'Start Writing......',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content:
              const Text('Do you want to save the journal before leaving?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Don't Save"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (controller.journalFormKey.currentState!.validate()) {
                  controller.submitJournalEntry();
                }
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
