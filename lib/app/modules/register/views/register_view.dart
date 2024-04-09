import 'package:fyp_rememory/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RegisterController());
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
                image: AssetImage('assets/images/SignUp.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'REGISTER',
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
                height: 20,
              ),
              Form(
                key: controller.registerFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 334,
                      height: 64,
                      child: TextFormField(
                        controller: controller.fullNameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'FULLNAME',
                          hintStyle: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            height: 0.08,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline_sharp,
                            size: 30,
                            color: Color.fromARGB(255, 96, 95, 95),
                          ),
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
                      ),
                    ),
                    SizedBox(
                      width: 334,
                      height: 64,
                      child: TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'EMAIL',
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
                            return 'Email is required';
                          } else if (!GetUtils.isEmail(value)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Adjust the spacing between text fields
                    SizedBox(
                      width: 334,
                      height: 64,
                      child: TextFormField(
                        controller: controller.passwordController,
                        obscureText: true,
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          } else if (!RegExp(
                                  r'(?=.*?[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-])')
                              .hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Adjust the spacing between text fields
                    SizedBox(
                      width: 334,
                      height: 64,
                      child: TextFormField(
                        controller: controller.confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'CONFIRM PASSWORD',
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
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm Password is required';
                          } else if (value !=
                              controller.passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Adjust the spacing between text fields

                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: SizedBox(
                        width: 338,
                        height: 65,
                        child: ElevatedButton(
                          onPressed: controller.onRegister,
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
                              'Sign up',
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
                          '             Already have account?',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.LOGIN);
                          },
                          child: Text(
                            'Login',
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
