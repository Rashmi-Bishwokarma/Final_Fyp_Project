import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed
    _database = await initializeDB();
    return _database!;
  }

  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'journal.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
          CREATE TABLE journals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            entry TEXT NOT NULL,
            mood TEXT,
            location TEXT,
            privacy TEXT,
            image TEXT,
            date TEXT
          )
          """,
        );
      },
      version: 1,
    );
  }

  Future<int> insertJournal(Map<String, dynamic> journal) async {
    final db = await database;
    return await db.insert('journals', journal);
  }

  Future<List<Map<String, dynamic>>> retrieveJournals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('journals');
    return maps;
  }

  Future<void> updateJournal(Map<String, dynamic> journal, int id) async {
    final db = await database;
    await db.update('journals', journal, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteJournal(int id) async {
    final db = await database;
    await db.delete('journals', where: 'id = ?', whereArgs: [id]);
  }
}
