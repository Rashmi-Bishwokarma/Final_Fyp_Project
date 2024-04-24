import 'package:fyp_rememory/app/modules/settings/controllers/settings_controller.dart';
import 'package:fyp_rememory/app/modules/sidebar/views/sidebar_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_rememory/app/modules/user_home/views/user_home_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsView extends StatelessWidget {
  final SettingsController settingsController = Get.put(SettingsController());

  SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SettingsController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_on_outlined,
              size: 30,
            ),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      drawer: const SidebarView(),
      body: ListView(
        children: [
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
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Get.to(() => UserHomeView());
            },
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
          Obx(() => SwitchListTile(
                secondary: const Icon(Icons.notifications_outlined, size: 30),
                title: Text('Notifications',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )),
                value: settingsController.isNotificationsEnabled.value,
                onChanged: settingsController.toggleNotifications,
              )),
          const SizedBox(
            height: 30,
          ),
          _buildContactSection(),
        ],
      ),
    );
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

  void _showChangePasswordDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Change Password',
      content: Form(
        key: settingsController.changePasswordFormKey,
        child: Column(
          children: [
            Obx(() => TextFormField(
                  controller: settingsController.oldPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    labelStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        settingsController.oldPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        settingsController.oldPasswordVisible.toggle();
                      },
                    ),
                  ),
                  obscureText: !settingsController.oldPasswordVisible.value,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter old password' : null,
                )),
            Obx(() => TextFormField(
                  controller: settingsController.newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        settingsController.newPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        settingsController.newPasswordVisible.toggle();
                      },
                    ),
                  ),
                  obscureText: !settingsController.newPasswordVisible.value,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter new password' : null,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (settingsController.changePasswordFormKey.currentState!
                    .validate()) {
                  settingsController.changePassword();
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
    Get.defaultDialog(
      title: 'Submit Feedback',
      content: Form(
        key: settingsController.feedbackFormKey,
        child: Column(
          children: [
            const Text('Rate Us',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: settingsController.rating.value.toDouble(),
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
                settingsController.rating.value = rating.toInt();
              },
            ),
            TextFormField(
              controller: settingsController.feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your Feedback',
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your feedback' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (settingsController.feedbackFormKey.currentState!
                    .validate()) {
                  settingsController.submitFeedback();
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
}
