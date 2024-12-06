import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:mark1/screens/favorite_news.dart';
import 'package:mark1/screens/home_page.dart';
import 'package:mark1/screens/news_sources.dart';
import 'package:mark1/screens/saved_news.dart';
import 'package:mark1/screens/sort_news.dart';
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
        home: const HomePage(),
      );
    });
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  // Index to keep track of the selected tab
  int _selectedIndex = 0;

  // List of screens that correspond to each tab
  final List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    const CategoryArticle(),
    SavedArticlesPage(),
  ];

  // Handle the tab change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],  // Display the selected screen here

      // Bottom Navigation Bar (CrystalNavigationBar or BottomNavigationBar)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withOpacity(0.5),
          onTap: _onItemTapped,
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.white,
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.heart,
              unselectedIcon: IconlyLight.heart,
              selectedColor: Colors.red,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: IconlyBold.filter_2,
              unselectedIcon: IconlyLight.filter,
              selectedColor: Colors.white,
            ),

            /// Search
            CrystalNavigationBarItem(
                icon: IconlyBold.bookmark,
                unselectedIcon: IconlyLight.bookmark,
                selectedColor: Colors.white),
          ],
        ),
      ),
    );
  }
}