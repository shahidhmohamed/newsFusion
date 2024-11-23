import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mark1/routing/app_pages.dart';
import 'package:mark1/routing/app_routes.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'News Fusion',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoute.HOME,
        getPages: getRoutes);
  }
}
