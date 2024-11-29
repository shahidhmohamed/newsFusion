import 'package:flutter/material.dart';
import 'package:mark1/models/news_article.dart';
import 'package:mark1/screens/view_news.dart';
import 'package:mark1/services/news_api_service.dart';
import 'package:intl/intl.dart';

class CategoryArticle extends StatefulWidget {
  const CategoryArticle({super.key});

  @override
  _CategoryArticleState createState() => _CategoryArticleState();
}

class _CategoryArticleState extends State<CategoryArticle> {
  late Future<List<NewsArticle>> _everything;
  String? _selectedSource;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _everything = NewsApiService().fetchEverything();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Search News by Source & Date',
          style: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _everything,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No articles found.',
                    style: TextStyle(color: Colors.white)));
          } else {
            final articles = snapshot.data!;

            final filteredArticles = articles.where((article) {
              bool matchesSource = _selectedSource == null ||
                  article.source.name == _selectedSource;

              bool matchesDate = _selectedDate == null ||
                  DateFormat('yyyy-MM-dd').format(article.publishedAt) ==
                      DateFormat('yyyy-MM-dd').format(_selectedDate!);

              return matchesSource && matchesDate;
            }).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(26.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedSource,
                          hint: const Center(
                            child: Text(
                              "Filter by Source",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          dropdownColor: Colors.grey[800],
                          items: articles
                              .map((article) => article.source.name)
                              .toSet()
                              .map((sourceName) => DropdownMenuItem<String>(
                                    value: sourceName,
                                    child: Text(
                                      sourceName,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSource = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 20.0),
                            ),
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                });
                              }
                            },
                            child: Text(
                              _selectedDate == null
                                  ? "Pick a Date"
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate!),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = filteredArticles[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: article.urlToImage != null
                              ? Image.network(
                                  article.urlToImage!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image, size: 50),
                          title: Text(
                            article.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            article.source.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewNewsPage(article: article),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
