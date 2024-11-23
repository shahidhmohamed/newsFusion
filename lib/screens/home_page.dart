import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mark1/models/news_article.dart';
import 'package:mark1/screens/view_news.dart';
import 'package:mark1/services/news_api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<NewsArticle>> _futureArticles;
  late Future<List<NewsArticle>> _everything;
  bool _isSearchActive = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;
  final List<String> _categories = ['Sports', 'Technology', 'Business'];

  String? _selectedCategory; // This will store the selected category


  @override
  void initState() {
    super.initState();

    _futureArticles = NewsApiService().fetchTopHeadlines(country: 'us');
    _everything = NewsApiService().fetchEverything();
    print("Fetching.....");
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation logic here based on the selected index
    switch (index) {
      case 0:
      // Stay on HomePage
        break;
      case 1:
        Navigator.pushNamed(context, '/category');
        break;
      case 2:
        Navigator.pushNamed(context, '/sources');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      //   title: const Text("News Fusion", style: TextStyle(color: Colors.white, fontSize: 24.0)),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.conveyor_belt, color: Colors.white, size: 30),
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/sources');
      //       },
      //     ),
      //   ],
      // ),
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Color(0xFF1A1A2E), // Top half gradient color
        //       Colors.white, // Bottom half white
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
               // Top color
              Colors.white, // Bottom color
              Color(0xFF1A1A2E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.topLeft,
            // stops: [0.4, 0.1],
            stops: [0.0, 0.5], // Ensures the color split happens at the middle
          ),
        ),
        // color: Color(0xFF1A1A2E),
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
                      padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "News ", // "News" part remains the default color
                                  style: TextStyle(color: Colors.white, fontSize: 25.0,fontWeight:FontWeight.w500),
                                ),
                                TextSpan(
                                  text: "Fusion", // "Fusion" part is blue
                                  style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 34.0,fontWeight:FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Helloo.... 👋",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.conveyor_belt, color: Colors.white, size: 30),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/sources');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
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
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            hintText: "Find Breaking News",
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
                      const Padding(
                        padding: EdgeInsets.all(12.0),

                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: " Head  Li", // "News" part remains the default color
                                style: TextStyle(color: Colors.white, fontSize: 18.0,fontWeight:FontWeight.w500 ),
                              ),
                              TextSpan(
                                text: "nes", // "Fusion" part is blue
                                style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18.0,fontWeight:FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_searchQuery.isEmpty)
                      SizedBox(
                        height: 330,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return Container(
                              width: 260,
                              margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                        builder: (context) => ViewNewsPage(article: article),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (article.urlToImage != null)
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(18)),
                                            child: Image.network(
                                              article.urlToImage!,
                                              height: 140,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          height: 120,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image, size: 50),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              article.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight:FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(height: 0),
                                            // Text(
                                            //   article.author ?? '',
                                            //   maxLines: 2,
                                            //   overflow: TextOverflow.ellipsis,
                                            // ),
                                            TextButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Colors.black),
                                                shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12), // Adjust corner radius here
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                article.author ?? '',
                                                style: const TextStyle(fontSize: 12, color: Colors.white), // Ensure text is visible
                                              ),
                                            ),
                                            const SizedBox(height: 04),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align content to ends of the Row
                                              children: [
                                                Row( // Wrap existing icon and text in a sub-Row
                                                  children: [
                                                    const Padding(padding: EdgeInsets.all(2.0)),
                                                    const Icon(Icons.access_time, size: 16, color: Colors.grey), // Add clock icon
                                                    const SizedBox(width: 5), // Space between icon and text
                                                    Text(
                                                      article.publishedAt != null
                                                          ? DateFormat('yMMMd').format(article.publishedAt) // Format as "Jan 1, 2024"
                                                          : '',
                                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                // Add the image at the end
                                                if (article.urlToImage != null)
                                                ClipRRect(

                                                  borderRadius: BorderRadius.circular(18), // Rounded corners for the image
                                                  child: Image.network(
                                                    article.urlToImage!,
                                                    height: 30, // Adjust the size as needed
                                                    width: 30,
                                                    fit: BoxFit.cover,
                                                  ),
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
                    // const Padding(
                    //   padding: EdgeInsets.all(10),
                    //   child: Text('All News',
                    //       style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    // ),
                    Column(
                      children: [
                        FutureBuilder<List<NewsArticle>>(
                          future: _everything,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No articles found.'));
                            } else {
                              final articles = snapshot.data!;
                              final filteredNews = articles
                                  .where((article) => article.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                                  .toList();

                              final displayList = _searchQuery.isEmpty ? articles : filteredNews;

                              return Column(
                                mainAxisSize: MainAxisSize.min,

                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5.0), // Adjust padding as needed
                                    child: Wrap(
                                      spacing: 10.0,
                                      children: _categories.map((category) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedCategory = category;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0), // Padding for individual chips
                                            child: Chip(
                                              label: Text(category),
                                              backgroundColor: _selectedCategory == category
                                                  ? const Color(0xFF1A1A2E)
                                                  : Colors.grey[300],
                                              labelStyle: TextStyle(
                                                color: _selectedCategory == category
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: displayList.length,
                                    itemBuilder: (context, index) {
                                      final article = displayList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ViewNewsPage(article: article),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if (article.urlToImage != null)
                                                    ClipRRect(
                                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                                      child: Image.network(
                                                        article.urlToImage!,
                                                        height: 120,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      height: 120,
                                                      color: Colors.grey[300],
                                                      child: const Icon(Icons.image, size: 50),
                                                    ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    article.title,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Top color
              Colors.white, // Bottom color
              Color(0xFF1A1A2E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.topLeft,
            // stops: [0.4, 0.1],
            stops: [0.0, 0.5],
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Set transparent to allow gradient to show
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
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
              icon: Icon(Icons.source),
              label: 'Sources',
            ),
          ],
        ),
      ),

    );
  }
}
