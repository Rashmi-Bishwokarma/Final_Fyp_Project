import 'package:fyp_rememory/app/components/footer.dart';
import 'package:fyp_rememory/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../../utils/constants.dart';
// Your ProfileController class

// ignore: must_be_immutable
class ProfileView extends GetView<ProfileController> {
  // Controllers for form inputs
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final RxString currentlyEditing = ''.obs;
  final RxBool isInEditMode = false.obs;
  final formKey = GlobalKey<FormState>();

  ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ProfileController>(() => ProfileController());
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
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
              ListTile(
                leading: const HeroIcon(HeroIcons.mapPin,
                    color: Color.fromARGB(255, 71, 58, 121)),
                title: isInEditMode.value
                    ? TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          hintText: "Address",
                        ),
                      )
                    : Text(
                        user.address ?? 'Not provided',
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
                leading: const HeroIcon(HeroIcons.cake,
                    color: Color.fromARGB(255, 71, 58, 121)),
                title: isInEditMode.value
                    ? TextField(
                        controller: dateOfBirthController,
                        decoration: const InputDecoration(
                          hintText: "Date of Birth",
                        ),
                      )
                    : Text(
                        user.dateOfBirth ?? 'Not provided',
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
                leading: const HeroIcon(HeroIcons.homeModern,
                    color: Color.fromARGB(255, 71, 58, 121)),
                title: isInEditMode.value
                    ? TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: "About You",
                        ),
                      )
                    : Text(
                        user.description ?? 'Not provided',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4),
    );
  }
}
