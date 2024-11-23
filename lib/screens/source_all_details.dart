import 'package:flutter/material.dart';
import 'package:mark1/models/news_article.dart';
import 'package:mark1/services/news_api_service.dart';

class SourceArticlesPage extends StatefulWidget {
  final String sourceId;
  final String sourceName;

  const SourceArticlesPage({required this.sourceId, required this.sourceName, Key? key}) : super(key: key);

  @override
  _SourceArticlesPageState createState() => _SourceArticlesPageState();
}

class _SourceArticlesPageState extends State<SourceArticlesPage> {
  late Future<List<NewsArticle>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = NewsApiService().fetchTopHeadlines(country: widget.sourceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sourceName),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found.'));
          } else {
            final articles = snapshot.data!;
            print(articles);
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      article.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      article.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // Optionally navigate to a detailed article page
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
