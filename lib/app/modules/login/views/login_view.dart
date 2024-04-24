import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage('assets/images/LoginPic.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: Text(
                  'LOGIN',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 0.02,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: controller.loginFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 334,
                      height: 64,
                      child: TextFormField(
                        controller: controller.identifierController,
                        // Updated controller name
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'EMAIL/FULL NAME', // Updated hint
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            height: 0.08,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 96, 95, 95),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email/Full Name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 334,
                      height: 64,
                      child: Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller
                                .isPasswordVisible.value, // Control visibility
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFD9D9D9),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'PASSWORD',
                              hintStyle: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 0.08,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline_sharp,
                                size: 30,
                                color: Color.fromARGB(255, 96, 95, 95),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: controller.togglePasswordVisibility,
                                child: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color.fromARGB(255, 96, 95, 95),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 180),
                      child: GestureDetector(
                        onTap: () {
                          // Handle forgot password
                        },
                        child: Text(
                          'Forgot password?',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 25),
                      child: SizedBox(
                        width: 338,
                        height: 65,
                        child: ElevatedButton(
                          onPressed: controller.onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF463A79), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4, // Shadow
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
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '       Don’t have an account? ',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.REGISTER);
                          },
                          child: Text(
                            'Register',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF473A79),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
