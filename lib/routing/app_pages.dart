import 'package:get/get.dart';
import 'package:mark1/screens/sort_news.dart';
import 'package:mark1/screens/home_page.dart';
import 'package:mark1/screens/news_sources.dart';
import 'app_routes.dart';

var getRoutes = [
  GetPage(name: AppRoute.HOME, page: () => HomePage()),
  GetPage(name: AppRoute.CATEGORY_NOTE, page: () => const CategoryArticle()),
  GetPage(name:AppRoute.NEWS_SOURCES, page: ()=> const NewsSourcesPage()),
];