import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('NewsFusion.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE news(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_id TEXT,
        source_name TEXT,
        author TEXT,
        title TEXT,
        description TEXT,
        url TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT
      )
    ''');

    // Create the 'favNews' table when the database is created
    await db.execute(''' 
      CREATE TABLE favNews(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_id TEXT,
        source_name TEXT,
        author TEXT,
        title TEXT,
        description TEXT,
        url TEXT,
        urlToImage TEXT,
        publishedAt TEXT,
        content TEXT
      )
    ''');
  }

  // This method handles database version upgrades
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(''' 
        CREATE TABLE favNews(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          source_id TEXT,
          source_name TEXT,
          author TEXT,
          title TEXT,
          description TEXT,
          url TEXT,
          urlToImage TEXT,
          publishedAt TEXT,
          content TEXT
        )
      ''');
    }
  }

  // Insert an article into the 'news' table
  Future<int> saveArticle(Map<String, dynamic> news) async {
    final db = await database;
    return await db.insert('news', news);
  }

  // Get all saved articles from the 'news' table
  Future<List<Map<String, dynamic>>> getSavedArticles() async {
    final db = await database;
    return await db.query('news');
  }

  // Delete an article from the 'news' table
  Future<void> deleteArticle(int id) async {
    final db = await database;
    await db.delete('news', where: 'id = ?', whereArgs: [id]);
  }

  // Update an article in the 'news' table
  Future<int> updateArticle(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    return await db.update(
      'news',
      updatedValues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert a favorite article into the 'favNews' table
  Future<int> saveFavoriteArticle(Map<String, dynamic> favoriteNews) async {
    final db = await database;
    return await db.insert('favNews', favoriteNews);
  }

  // Get all favorite articles from the 'favNews' table
  Future<List<Map<String, dynamic>>> getFavoriteArticles() async {
    final db = await database;
    return await db.query('favNews');
  }

  // Delete a favorite article from the 'favNews' table
  Future<void> deleteFavoriteArticle(int id) async {
    final db = await database;
    await db.delete('favNews', where: 'id = ?', whereArgs: [id]);
  }

  // Update a favorite article in the 'favNews' table
  Future<int> updateFavoriteArticle(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    return await db.update(
      'favNews',
      updatedValues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
