import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:fyp_rememory/app/modules/adminProfile/controllers/admin_profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../../utils/constants.dart';
// Your AdminProfileController class

// ignore: must_be_immutable
class AdminProfileView extends GetView<AdminProfileController> {
  final AdminProfileController adminProfileController =
      Get.put(AdminProfileController());
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final RxString currentlyEditing = ''.obs;
  final RxBool isInEditMode = false.obs;
  final formKey = GlobalKey<FormState>();

  AdminProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<AdminProfileController>(() => AdminProfileController());
    ever(controller.userResponse, (_) {
      var user = controller.userResponse.value?.user;
      if (user != null) {
        // Initialize controllers with user's current data
        fullNameController = TextEditingController(text: user.fullName ?? '');
        emailController = TextEditingController(text: user.email ?? '');
        dateOfBirthController =
            TextEditingController(text: user.dateOfBirth ?? '');
        addressController = TextEditingController(text: user.address ?? '');
        descriptionController =
            TextEditingController(text: user.description ?? '');
      }
    });
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 254, 255),
          borderRadius: BorderRadius.circular(
              8), // Applies a 5 pixels radius uniformly to all corners
        ),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 252, 254, 255),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 252, 254, 255),
            title: const Text('Admin Profile'),
            centerTitle: true,
            actions: [
              Obx(() => IconButton(
                    icon: Icon(isInEditMode.value ? Icons.check : Icons.edit),
                    onPressed: () {
                      if (isInEditMode.value) {
                        // If in edit mode, validate all form fields
                        if (formKey.currentState!.validate()) {
                          // If the form is valid, save the changes
                          controller.updateUserProfile(
                            fullName: fullNameController.text,
                            email: emailController.text,
                            dateOfBirth: dateOfBirthController.text,
                            address: addressController.text,
                            description: descriptionController.text,
                            // Add more parameters as needed
                          );
                        }
                      }
                      isInEditMode.toggle(); // Switch between edit/view mode
                    },
                  ))
            ],
          ),
          body: Obx(() {
            if (controller.userResponse.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = controller.userResponse.value!.user;
            String profileImageUrl = getImageUrl(user?.profileImage ?? '');
            if (user == null) {
              return const Center(child: Text('User data not available'));
            }

            // If we have user data, we can display it
            return Form(
              key: formKey,
              child: ListView(
                children: [
                  Container(
                    width: 150, // Width of the circle
                    height: 150, // Height of the circle
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: user.profileImage != null
                          ? DecorationImage(
                              image: NetworkImage(profileImageUrl),
                              fit: BoxFit
                                  .contain, // This will cover the circular area, might crop
                            )
                          : null,
                    ),
                    child: user.profileImage == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.role ?? 'Not provided',
                        style: GoogleFonts.montserrat(
                          color: const Color.fromARGB(255, 71, 58, 121),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [],
                  ),
                  ListTile(
                    leading: const HeroIcon(HeroIcons.user,
                        color: Color.fromARGB(255, 71, 58, 121)),
                    title: isInEditMode.value
                        ? TextFormField(
                            controller: fullNameController,
                            decoration: const InputDecoration(
                              hintText: "Full Name",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }

                              final words = value.split(' ');

                              if (words.length < 2 || words.length > 3) {
                                return 'Name should consist of 2 or 3 words';
                              }

                              return null;
                            },
                          )
                        : Text(
                            user.fullName ?? 'Not provided',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 17, right: 17),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  ListTile(
                    leading: const HeroIcon(HeroIcons.envelope,
                        color: Color.fromARGB(255, 71, 58, 121)),
                    title: isInEditMode.value
                        ? TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              } else if (!GetUtils.isEmail(value)) {
                                return 'Invalid email format';
                              }
                              return null;
                            },
                          )
                        : Text(
                            user.email ?? 'Not provided',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 17, right: 17),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Settings',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  _buildSettingsOption(
                    icon: Icons.lock_outlined,
                    title: 'Change Password',
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  _buildSettingsOption(
                    icon: Icons.feedback_outlined,
                    title: 'Feedback',
                    onTap: () => _showFeedbackDialog(context),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildContactSection(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

ListTile _buildSettingsOption({
  required IconData icon,
  required String title,
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: Icon(icon, size: 30),
    title: Text(title,
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        )),
    trailing: const Icon(Icons.arrow_forward_ios),
    onTap: onTap,
  );
}

Widget _buildContactSection() {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromRGBO(232, 230, 250, 1),
      borderRadius: BorderRadius.circular(15),
    ),
    height: 150,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'If you have any other query you can reach out to us.',
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/icon/gmail.png'),
                height: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage('assets/icon/facebook.png'),
                height: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage('assets/icon/instagram.png'),
                height: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage('assets/icon/social.png'),
                height: 25,
              ),
            ],
          ),
        ],
      ),
    ),
  );
  // Contact section widget code
}

// Function to show change password dialog
void _showChangePasswordDialog(BuildContext context) {
  final AdminProfileController adminProfileController =
      Get.put(AdminProfileController());
  Get.defaultDialog(
    title: 'Change Password',
    content: Form(
      key: adminProfileController.changePasswordFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: adminProfileController.oldPasswordController,
            decoration: const InputDecoration(labelText: 'Old Password'),
            obscureText: true,
            validator: (value) =>
                value!.isEmpty ? 'Please enter old password' : null,
          ),
          TextFormField(
            controller: adminProfileController.newPasswordController,
            decoration: const InputDecoration(labelText: 'New Password'),
            obscureText: true,
            validator: (value) =>
                value!.isEmpty ? 'Please enter new password' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (adminProfileController.changePasswordFormKey.currentState!
                  .validate()) {
                adminProfileController.changePassword();
                Get.back();
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    ),
  );
}

// Function to show feedback dialog
void _showFeedbackDialog(BuildContext context) {
  final AdminProfileController adminProfileController =
      Get.put(AdminProfileController());
  Get.defaultDialog(
    title: 'Submit Feedback',
    content: Form(
      key: adminProfileController.feedbackFormKey,
      child: Column(
        children: [
          const Text('Rate Us', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          RatingBar.builder(
            initialRating: adminProfileController.rating.value.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              adminProfileController.rating.value = rating.toInt();
            },
          ),
          TextFormField(
            controller: adminProfileController.feedbackController,
            decoration: const InputDecoration(labelText: 'Your Feedback'),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your feedback' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (adminProfileController.feedbackFormKey.currentState!
                  .validate()) {
                adminProfileController.submitFeedback();
                Get.back();
              }
            },
            child: const Text('Submit Feedback'),
          ),
        ],
      ),
    ),
  );
}
