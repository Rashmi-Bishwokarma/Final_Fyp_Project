import 'package:fyp_rememory/app/modules/login/views/login_view.dart';
import 'package:fyp_rememory/app/modules/register/views/register_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/welcome_page_controller.dart';

class WelcomePageView extends GetView<WelcomePageController> {
  const WelcomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage('assets/images/FinalLogo.png'),
            ),
            Text(
              'Hello',
              textAlign: TextAlign.center,
              style: GoogleFonts.inika(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Welcome to rememory ,where \nyou can write your thoughts',
              textAlign: TextAlign.center,
              style: GoogleFonts.inika(
                color: const Color(0xFF756F6F),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const RegisterView());
              },
              child: Container(
                  width: 318,
                  height: 59,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF473A79),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Sign up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const LoginView());
              },
              child: Container(
                  width: 318,
                  height: 59,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF473A79),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Sign in',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    ));
  }
}
