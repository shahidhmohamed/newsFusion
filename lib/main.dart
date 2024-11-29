import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mark1/routing/app_pages.dart';
import 'package:mark1/routing/app_routes.dart';
import 'package:mark1/widgets/theme_controller.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() {
      return GetMaterialApp(
        title: 'News Fusion',
        debugShowCheckedModeBanner: false,
        theme: themeController.isDarkMode.value
            ? ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
        )
            : ThemeData.light().copyWith(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: AppRoute.HOME,
        getPages: getRoutes,
      );
    });
  }
}
