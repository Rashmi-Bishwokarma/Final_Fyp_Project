import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Memory.init();
  var token = Memory.getToken();
  var role = Memory.getRole();
  var isUser = role == 'user';
  var isAdmin = role == 'admin';
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: token == null
          ? Routes.WELCOME_PAGE
          : isUser
              ? Routes.USER_HOME
              : isAdmin
                  ? Routes.ADMIN
                  : Routes.ADMIN,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    ),
  );
}
