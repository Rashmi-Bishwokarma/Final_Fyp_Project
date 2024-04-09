import 'package:flutter/material.dart';
import 'package:fyp_rememory/app/modules/payment/views/payment_view.dart';
import 'package:fyp_rememory/app/modules/showNote/views/show_note_view.dart';
import 'package:fyp_rememory/app/modules/showjournal/views/showjournal_view.dart';

import 'package:get/get.dart';

import '../controllers/sidebar_controller.dart';

import 'package:fyp_rememory/app/modules/settings/views/settings_view.dart';

import 'package:fyp_rememory/app/routes/app_pages.dart';

import 'package:fyp_rememory/app/utils/memory.dart';

import 'package:google_fonts/google_fonts.dart';

class SidebarView extends GetView<SidebarController> {
  const SidebarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 290,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 246, 246),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 2,
            color: const Color(0xFF473A79),
          ),
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/Rememory.png'),
                    height: 150,
                    width: 150,
                  ),
                ],
              ),
              _createDrawerItem(
                icon: Icons.tag_outlined,
                text: 'Tags',
                onTap: () {
                  Get.to(() => ShowJournalView());
                },
              ),
              _createDrawerItem(
                icon: Icons.note_outlined,
                text: 'Notes',
                onTap: () {
                  Get.to(() => const ShowNoteView());
                },
              ),
              _createDrawerItem(
                icon: Icons.book_outlined,
                text: 'Journal',
                onTap: () {
                  Get.to(() => ShowJournalView());
                },
              ),
              _createDrawerItem(
                icon: Icons.payment_outlined,
                text: 'Payment',
                onTap: () => Get.to(() => PaymentView()),
              ),
              _createDrawerItem(
                icon: Icons.settings_outlined,
                text: 'Settings',
                onTap: () => Get.to(() => SettingsView()),
              ),
              const SizedBox(
                height: 200,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          content:
                              const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Memory.clear();
                                Get.offAllNamed(Routes.WELCOME_PAGE);
                              },
                              child: const Text('Logout'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                        size: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Log out',
                          style: GoogleFonts.montserrat(
                            fontSize: 19,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: const Color(0xFF473A79),
            size: 32,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
