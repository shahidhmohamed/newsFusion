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

    return openDatabase(path, version: 1, onCreate: _onCreate);
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
  }

  Future<int> saveArticle(Map<String, dynamic> news) async {
    final db = await database;

    return await db.insert('news', news);
  }

  Future<List<Map<String, dynamic>>> getSavedArticles() async {
    final db = await database;
    return await db.query('news');
  }

  Future<void> deleteArticle(int id) async {
    final db = await database;

    await db.delete('news', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateArticle(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;
    return await db.update(
      'news',
      updatedValues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
