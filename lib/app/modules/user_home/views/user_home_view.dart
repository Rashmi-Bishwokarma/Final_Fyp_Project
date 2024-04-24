import 'package:fyp_rememory/app/components/footer.dart';
import 'package:fyp_rememory/app/modules/journal/views/journal_view.dart';
import 'package:fyp_rememory/app/modules/sidebar/views/sidebar_view.dart';
import 'package:fyp_rememory/app/modules/user_home/controllers/user_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class UserHomeView extends GetView<UserHomeController> {
  final DateTime now = DateTime.now();

  UserHomeView({Key? key}) : super(key: key);

  String getGreeting() {
    var hour = now.hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserHomeController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              size: 30,
            ),
            onPressed: () {
              Get.to(() => JournalView());
            },
          ),
        ],
      ),
      drawer: const SidebarView(),
      body: SingleChildScrollView(
        child: GetBuilder<UserHomeController>(
          builder: (UserHomeController controller) {
            if (controller.userResponse == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(children: [
              Stack(
                children: [
                  // Background Container
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 412,
                      height: 250,
                      decoration: ShapeDecoration(
                        color: const Color.fromRGBO(188, 163, 208, 0.68),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 73, left: 40),
                        child: Text(
                          '${getGreeting()}, ${(controller.userResponse?.user?.fullName ?? '').split(' ')[0]}!',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Overlay Container

                  Padding(
                    padding:
                        const EdgeInsets.only(top: 130.0, left: 25, right: 0),
                    child: Container(
                      width: 360,
                      height: 155,
                      decoration: ShapeDecoration(
                        color: const Color.fromRGBO(216, 213, 243, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '“Always believe something wonderful is about to happen.”',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 25),
                child: Row(
                  children: [
                    Text(
                      'NOTES',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 260,
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        if (controller.noteFormKey.currentState!.validate()) {
                          // If the form is valid, submit the journal entry
                          controller.submitNote();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
                child: Container(
                  width: 412,
                  height: 117,
                  decoration: ShapeDecoration(
                    color: const Color.fromRGBO(244, 251, 198, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Form(
                    key: controller.noteFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: controller
                            .noteContentController, // Use the controller here
                        decoration: InputDecoration(
                          hintText: '      Start writing....',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors
                                .grey, // You can set the color as per your preference
                            // Optional, set the style
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13.0, left: 25),
                child: Row(
                  children: [
                    Text(
                      'JOURNAL ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 225,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: 395,
                      height: 117,
                      decoration: ShapeDecoration(
                        color: const Color.fromRGBO(244, 245, 246, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the welcome page
                          Get.to(() => const JournalView());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeroIcon(
                              HeroIcons.documentPlus,
                              style: HeroIconStyle.outline,
                              size: 24,
                            ),
                            Text(
                              "Tap For New",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}
