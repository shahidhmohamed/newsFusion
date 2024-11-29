import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mark1/db_helper/db_connection.dart';
import 'package:mark1/models/news_article.dart';
import 'package:mark1/models/source..dart';
import 'package:mark1/screens/view_news.dart';
import 'package:mark1/services/news_api_service.dart';
import 'package:mark1/widgets/theme_controller.dart';
import '../models/global_fav.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<NewsArticle>> _futureArticles;
  late Future<List<NewsArticle>> _everything;
  late Future<List<Source>> _source;
  bool _isSearchActive = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;
  late List<String> _categories = [];
  final ThemeController themeController = Get.find();

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _futureArticles = NewsApiService().fetchTopHeadlines(country: 'us');
    _everything = NewsApiService().fetchEverything();
    _source = NewsApiService().fetchSources();
    _loadCategories();
    print("Fetching.....");
  }

  Future<void> _loadCategories() async {
    try {
      final sources = await _source;

      final categories = sources
          .map((source) => source.category)
          .whereType<String>()
          .toSet()
          .toList();

      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/category');
        break;
      case 2:
        Navigator.pushNamed(context, '/fav');
        break;
      case 3:
        Navigator.pushNamed(context, '/saved-news');
        break;
      case 4:
        Navigator.pushNamed(context, '/sources');
        break;
    }
  }

  Future<void> _saveArticle(NewsArticle article) async {
    try {
      final articleMap = article.toJson();

      await DatabaseHelper.instance.saveArticle(articleMap);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article saved to device!')),
      );
    } catch (e) {
      print('Error saving article: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    Colors.black,
                    Colors.white,
                  ]
                : [
                    Colors.white,
                    Color(0xFF1A1A2E),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.topLeft,
            stops: [0.1, 0.0],
          ),
        ),
        child: FutureBuilder<List<NewsArticle>>(
          future: _futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No articles found.'));
            } else {
              final articles = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 50.0, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "NEWS",
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 37.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: " FUSION",
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Color(0xFF1A1A2E),
                                      fontSize: 37.0,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Helloo.... 👋",
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: Obx(() => Icon(
                                      themeController.isDarkMode.value
                                          ? Icons.light_mode
                                          : Icons.dark_mode,
                                    )),
                                onPressed: () {
                                  themeController.toggleTheme();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Discover Bre",
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: "aking News",
                              style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Color(0xFF1A1A2E),
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                              _isSearchActive = true;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.grey),
                            hintText: "Find Breaking News",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.purple, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.purple, width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                        _isSearchActive = false;
                                      });
                                    },
                                    child: const Icon(Icons.close),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    if (_searchQuery.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: " Head  Li",
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text: "nes",
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_searchQuery.isEmpty)
                      SizedBox(
                        height: 380,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Container(
                              width: 260,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewNewsPage(article: article),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (article.urlToImage != null)
                                        Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(18)),
                                                child: Image.network(
                                                  article.urlToImage!,
                                                  height: 140,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 22,
                                              right: 22,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .cloud_download,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                  onPressed: () {
                                                    _saveArticle(article);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article.title ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black),
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                article.author ?? '',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(height: 04),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Padding(
                                                        padding: EdgeInsets.all(
                                                            2.0)),
                                                    const Icon(
                                                        Icons.access_time,
                                                        size: 16,
                                                        color: Colors.grey),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      article.publishedAt !=
                                                              null
                                                          ? DateFormat('yMMMd')
                                                              .format(article
                                                                  .publishedAt)
                                                          : '',
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(
                                                      height: 60,
                                                      width: 10,
                                                    )
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    CupertinoIcons.share,
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    size: 40.0,
                                                  ),
                                                  onPressed: () {
                                                    final articleUrl =
                                                        article.url ??
                                                            'No URL available';
                                                    final articleTitle =
                                                        article.title;
                                                    Share.share(
                                                      'Check out this article: $articleTitle\n\nRead more at: $articleUrl',
                                                      subject:
                                                          'Sharing an article',
                                                    );
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
                            );
                          },
                        ),
                      ),
                    Column(
                      children: [
                        FutureBuilder<List<NewsArticle>>(
                          future: _everything,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No articles found.'));
                            } else {
                              final articles = snapshot.data!;
                              final filteredNews = articles
                                  .where((article) => article.title!
                                      .toLowerCase()
                                      .contains(_searchQuery.toLowerCase()))
                                  .toList();

                              final displayList = _searchQuery.isEmpty
                                  ? articles
                                  : filteredNews;

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 5,
                                        right: 5.0),
                                    child: Wrap(
                                      spacing: 10.0,
                                      children: _categories.map((category) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedCategory = category;

                                              displayList.sort((a, b) {
                                                final isACategory = a.title!
                                                    .toLowerCase()
                                                    .contains(_selectedCategory!
                                                        .toLowerCase());
                                                final isBCategory = b.title!
                                                    .toLowerCase()
                                                    .contains(_selectedCategory!
                                                        .toLowerCase());

                                                if (isACategory && !isBCategory)
                                                  return -1;
                                                if (!isACategory && isBCategory)
                                                  return 1;
                                                return 0;
                                              });
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 0),
                                            child: Chip(
                                              label: Text(category),
                                              backgroundColor:
                                                  _selectedCategory == category
                                                      ? (isDarkMode
                                                          ? const Color(
                                                              0xFF1A1A2E)
                                                          : const Color(
                                                              0xFF1A1A2E))
                                                      : (isDarkMode
                                                          ? Colors.grey[800]
                                                          : Colors.grey[300]),
                                              labelStyle: TextStyle(
                                                color: _selectedCategory ==
                                                        category
                                                    ? (isDarkMode
                                                        ? Colors.blue
                                                        : Colors.blue)
                                                    : (isDarkMode
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: displayList.length,
                                    itemBuilder: (context, index) {
                                      final article = displayList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewNewsPage(
                                                      article: article),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 120,
                                          width: 100,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 20.0),
                                          child: Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (article.urlToImage !=
                                                        null)
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          article.urlToImage!,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Container(
                                                              height: 100,
                                                              width: 100,
                                                              color: Colors
                                                                  .grey[300],
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
                                                        height: 200,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            article.title ?? '',
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 80,
                                                                height: 40,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.black),
                                                                    shape:
                                                                        MaterialStateProperty
                                                                            .all(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    article
                                                                        .source
                                                                        .name,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  FavoriteArticles
                                                                          .favorites
                                                                          .contains(
                                                                              article)
                                                                      ? Icons
                                                                          .favorite
                                                                      : Icons
                                                                          .favorite_border,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if (FavoriteArticles
                                                                        .favorites
                                                                        .contains(
                                                                            article)) {
                                                                      FavoriteArticles
                                                                          .favorites
                                                                          .remove(
                                                                              article);
                                                                    } else {
                                                                      FavoriteArticles
                                                                          .favorites
                                                                          .add(
                                                                              article);
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                              Container(
                                                                height: 35,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                    IconButton(
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .download,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    _saveArticle(
                                                                        article);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Colors.white]
                : [Color(0xFF1A1A2E), Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topLeft,
            stops: [0.1, 0],
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF1A1A2E),
          selectedItemColor: isDarkMode ? Colors.white : Color(0xFF1A1A2E),
          unselectedItemColor: isDarkMode
              ? Colors.white.withOpacity(0.7)
              : const Color(0xFF1A1A2E).withOpacity(0.5),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sort),
              label: 'Sort',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Fav',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.source),
              label: 'Sources',
            ),
          ],
        ),
      ),
    );
  }
}
