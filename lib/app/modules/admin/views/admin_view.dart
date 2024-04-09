import 'package:fyp_rememory/app/modules/admin/controllers/admin_controller.dart';

import 'package:flutter/material.dart';
import 'package:fyp_rememory/app/modules/adminpayment/views/adminpayment_view.dart';
import 'package:fyp_rememory/app/modules/dashboard/views/dashboard_view.dart';
import 'package:fyp_rememory/app/modules/feedback/views/feedback_view.dart';
import 'package:fyp_rememory/app/modules/notify/views/notify_view.dart';
import 'package:fyp_rememory/app/modules/profile/views/profile_view.dart';
import 'package:fyp_rememory/app/modules/userlist/views/userlist_view.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../settings/views/settings_view.dart';
import '../../showJournalAdmin/views/show_journal_admin_view.dart';

class AdminView extends GetView<AdminController> {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 243, 244),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Sidebar
            Expanded(
              flex: 2, // adjust the size ratio of the sidebar and content area
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(255, 252, 254,
                      255), // Applies a 5 pixels radius uniformly to all corners
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Image(
                      image: AssetImage('assets/images/Rememory.png'),
                      height: 150,
                      width: 150,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.dashboard_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for Dashboard
                      title: Text(
                        'Dashboard',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        controller.changePage(DashboardView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.payment_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for Payment List
                      title: Text(
                        'Payment List',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        controller.changePage(AdminpaymentView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.public_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for Public Journal
                      title: Text(
                        'Public Journal',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        // Assuming you have a SettingsPage widget
                        controller.changePage(ShowJournalAdminView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.people_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for User List
                      title: Text(
                        'User List',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        controller.changePage(UserListView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.feedback_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for Feedbacks
                      title: Text(
                        'Feedbacks',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        controller.changePage(FeedbackView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for Notifications
                      title: Text(
                        'Notifications',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        controller.changePage(NotifyView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for Settings
                      title: Text(
                        'Settings',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        // Assuming you have a SettingsPage widget
                        controller.changePage(SettingsView());
                      },
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.account_circle_outlined,
                        color: Color.fromARGB(255, 71, 58, 121),
                      ), // Icon for Admin Profile
                      title: Text(
                        'Admin Profile',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        controller.changePage(ProfileView());
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Content Area
            Expanded(
              flex: 8, // adjust the size ratio
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color.fromARGB(255, 221, 227,
                      230), // Applies a 5 pixels radius uniformly to all corners
                ),
                child: Obx(() => controller.currentPage.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
