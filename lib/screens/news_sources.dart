import 'package:flutter/material.dart';
import 'package:mark1/models/source..dart';
import 'package:mark1/screens/source_all_details.dart';
import 'package:mark1/services/news_api_service.dart';

class NewsSourcesPage extends StatefulWidget {
  const NewsSourcesPage({Key? key}) : super(key: key);

  @override
  _NewsSourcesPageState createState() => _NewsSourcesPageState();
}

class _NewsSourcesPageState extends State<NewsSourcesPage> {
  late Future<List<Source>> _sourcesFuture;

  @override
  void initState() {
    super.initState();
    _sourcesFuture = NewsApiService().fetchSources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text("News Fusion", style: TextStyle(color: Colors.white, fontSize: 20.0)),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Source>>(
        future: _sourcesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sources found.'));
          } else {
            final sources = snapshot.data!;
            return ListView.builder(
              itemCount: sources.length,
              itemBuilder: (context, index) {
                final source = sources[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      source.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          source.description ?? 'No description available',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Category: ${source.category}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Add navigation to a page that displays articles for this source
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SourceArticlesPage(sourceId: source.id?.toString() ?? '', sourceName: source.name),
                        ),
                      );
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
