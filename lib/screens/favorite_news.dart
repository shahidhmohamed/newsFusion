import 'package:flutter/material.dart';
import '../models/global_fav.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: FavoriteArticles.favorites.isEmpty
          ? const Center(child: Text("No favorites added yet!"))
          : ListView.builder(
        itemCount: FavoriteArticles.favorites.length,
        itemBuilder: (context, index) {
          final article = FavoriteArticles.favorites[index];
          return ListTile(
            leading: article.urlToImage != null
                ? Image.network(
              article.urlToImage!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.image),
            title: Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(article.source.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FavoriteArticles.favorites.remove(article);
                // Force the UI to update after deletion
                (context as Element).reassemble();
              },
            ),
          );
        },
      ),
    );
  }
}
