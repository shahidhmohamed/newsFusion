import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mark1/models/source..dart';
import '../models/news_article.dart';

class NewsApiService {
  static const String _apiKey = 'c4922c51edf440dd953a3bf982b92351';
  static const String _baseUrl = 'https://newsapi.org/v2';

  // Fetch Top Headlines
  Future<List<NewsArticle>> fetchTopHeadlines({String? country}) async {
    final url = Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Headlines response: $jsonData");
      final List articles = jsonData['articles'];
      return articles.map((e) => NewsArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  // Every News Articles
  Future<List<NewsArticle>> fetchEverything() async {
    final url = Uri.parse('$_baseUrl/everything?q=bitcoin&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("everything: $jsonData");
      final List articles = jsonData['articles'];
      return articles.map((e) => NewsArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search articles');
    }
  }

  // Fetch Sources
  Future<List<Source>> fetchSources() async {
    final url = Uri.parse('$_baseUrl/top-headlines/sources?apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List sources = jsonData['sources'];
      return sources.map((e) => Source.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load sources');
    }
  }

  // Search News by Date
  Future<List<NewsArticle>> searchNews(String from) async {
    final url = Uri.parse('$_baseUrl/everything?q=Apple&from=$from&sortBy=popularity&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Search News response: $jsonData");
      final List articles = jsonData['articles'];
      return articles.map((e) => NewsArticle.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search news');
    }
  }

}
