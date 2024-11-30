import 'package:flutter/material.dart';
import 'package:mark1/main.dart';
import 'package:mark1/models/news_article.dart';
import 'package:mark1/screens/view_news.dart';
import 'package:mark1/services/news_api_service.dart';
import 'package:intl/intl.dart';

class CategoryArticle extends StatefulWidget {
  const CategoryArticle({Key? key}) : super(key: key);

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Search News',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors:[
                  // Top part (blue)
                  Colors.black, // Top part (blue)
                  Colors.black, // Dark color for the bottom part
                  Color(0xFF1A1A2E),
                  Colors.white, // Lighter color for the bottom part
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.4, 0.4,0.7, 8], // You can adjust the stops to change the size of each section
              ),
            ),
          ),
          FutureBuilder<List<NewsArticle>>(
            future: _everything,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No articles found.', style: TextStyle(color: Colors.white)),
                );
              } else {
                final articles = snapshot.data!;

                final filteredArticles = articles.where((article) {
                  bool matchesSource =
                      _selectedSource == null || article.source.name == _selectedSource;
                  bool matchesDate = _selectedDate == null ||
                      DateFormat('yyyy-MM-dd').format(article.publishedAt) ==
                          DateFormat('yyyy-MM-dd').format(_selectedDate!);
                  return matchesSource && matchesDate;
                }).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 110.0, left: 16.0,right: 16.0),
                    child: Column(
                      children: [
                        DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedSource,
                          hint: const Text('Filter by Source', style: TextStyle(color: Colors.white)),
                          dropdownColor: Colors.grey[800],
                          items: articles
                              .map((article) => article.source.name)
                              .toSet()
                              .map((source) => DropdownMenuItem<String>(
                            value: source,
                            child: Text(source, style: const TextStyle(color: Colors.white)),
                          ))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedSource = value),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
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
                          style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
                          child: Text(
                            _selectedDate == null
                                ? "Pick a Date"
                                : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredArticles.length,
                          itemBuilder: (context, index) {
                            final article = filteredArticles[index];
                            return Card(
                              color: Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                              child: ListTile(
                                leading: article.urlToImage != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    article.urlToImage!,
                                    height: 160,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : const Icon(Icons.image, size: 60, color: Colors.white38),
                                title: Text(article.title!, style: const TextStyle(color: Colors.white,fontSize: 10)),
                                subtitle: Text(article.source.name,
                                    style: const TextStyle(color: Colors.grey)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewNewsPage(article: article),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
