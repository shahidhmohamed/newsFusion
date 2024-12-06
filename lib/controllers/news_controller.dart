import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mark1/models/news_article.dart';
import 'package:mark1/models/source..dart';

class NewsApiController extends GetxController {
  static const String _apiKey = 'c4922c51edf440dd953a3bf982b92351';
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Observables for state management
  var topHeadlines = <NewsArticle>[].obs;
  var everything = <NewsArticle>[].obs;
  var sources = <Source>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  // Fetch Top Headlines
  Future<void> fetchTopHeadlines({String? country = 'us'}) async {
    try {
      isLoading.value = true;
      error.value = '';
      final url = Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List articles = jsonData['articles'];
        topHeadlines.value = articles.map((e) => NewsArticle.fromJson(e)).toList();
      } else {
        error.value = 'Failed to load top headlines';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch Everything
  Future<void> fetchEverything(String query) async {
    try {
      isLoading.value = true;
      error.value = '';
      final url = Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List articles = jsonData['articles'];
        everything.value = articles.map((e) => NewsArticle.fromJson(e)).toList();
      } else {
        error.value = 'Failed to load articles';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch Sources
  Future<void> fetchSources() async {
    try {
      isLoading.value = true;
      error.value = '';
      final url = Uri.parse('$_baseUrl/top-headlines/sources?apiKey=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List sourcesData = jsonData['sources'];
        sources.value = sourcesData.map((e) => Source.fromJson(e)).toList();
      } else {
        error.value = 'Failed to load sources';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Search News by Date
  Future<void> searchNews(String from) async {
    try {
      isLoading.value = true;
      error.value = '';
      final url = Uri.parse('$_baseUrl/everything?q=Apple&from=$from&sortBy=popularity&apiKey=$_apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List articles = jsonData['articles'];
        everything.value = articles.map((e) => NewsArticle.fromJson(e)).toList();
      } else {
        error.value = 'Failed to search news';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
