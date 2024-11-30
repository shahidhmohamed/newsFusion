import 'package:flutter/material.dart';
import 'package:mark1/db_helper/db_connection.dart';
import 'package:mark1/main.dart';
import 'package:mark1/models/news_article.dart';
import 'package:mark1/screens/update_saved_news.dart';
import 'package:mark1/screens/view_news.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _databaseHelper = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> _getFavNews() async {
    return await _databaseHelper.getFavoriteArticles();
  }

  Future<void> _deleteFavNews(int id) async {
    try {
      await _databaseHelper.deleteFavoriteArticle(id);

      // Show SnackBar after successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'News deleted!',
            style: TextStyle(
              fontWeight: FontWeight.bold,      // Bold text
              color: Colors.white,              // White text color
              fontSize: 16,                     // Slightly larger font size
            ),
          ),
          backgroundColor: Colors.red,          // Red background for error/success
          duration: const Duration(seconds: 3), // Display duration
          behavior: SnackBarBehavior.floating,   // Floating position
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Padding
        ),
      );

      setState(() {});
    } catch (e) {
      print('Error deleting article: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  top: 60.0, left: 90.0, right: 90.0, bottom: 10.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    'FAVORITE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _getFavNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No saved articles.'));
                  } else {
                    final savedArticles = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: savedArticles.length,
                      itemBuilder: (context, index) {
                        final article = savedArticles[index];

                        return GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateNews(
                                  id: article['id'],
                                  initialTitle: article['title'] ?? '',
                                  initialDescription:
                                  article['description'] ?? '',
                                ),
                              ),
                            );

                            if (updated == true) {
                              // Show update success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'News Updated',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,      // Bold text
                                      color: Colors.white,              // White text color
                                      fontSize: 16,                     // Slightly larger font size
                                    ),
                                  ),
                                  backgroundColor: Colors.green,          // Red background for error/success
                                  duration: const Duration(seconds: 3), // Display duration
                                  behavior: SnackBarBehavior.floating,   // Floating position
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Padding
                                ),
                              );
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 130,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (article['urlToImage'] != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          article['urlToImage'],
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 100,
                                              width: 100,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    else
                                      Container(
                                        height: 100,
                                        width: 100,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article['title'] ?? 'No Title',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 40,
                                                child: TextButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all(Colors.black),
                                                    shape: MaterialStateProperty
                                                        .all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    article['source_name'] ??
                                                        'No Source',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  _deleteFavNews(article['id']);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
