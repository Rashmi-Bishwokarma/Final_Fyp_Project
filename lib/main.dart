import 'package:fyp_rememory/app/utils/memory.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Memory.init();
  var token = Memory.getToken();
  var role = Memory.getRole();
  var isUser = role == 'user';
  var isAdmin = role == 'admin';
  //HiveManager.initHive();
  runApp(
    KhaltiScope(
      publicKey: "test_public_key_5e309767f5714d01aa4978c2564cbb39",
      builder: (context, navigatorKey) => GetMaterialApp(
        navigatorKey: navigatorKey,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ne', 'NP'),
        ],
        localizationsDelegates: const [
          KhaltiLocalizations.delegate,
        ],
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
    ),
  );
}
