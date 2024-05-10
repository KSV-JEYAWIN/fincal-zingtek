import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'percentage_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE percentages(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      x INTEGER,
      y INTEGER,
      value REAL,
      datetime TEXT DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'NOW'))
    )
  ''');

    await db.execute('''
    CREATE TABLE incordec(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      x INTEGER,
      y INTEGER,
      increasedValue REAL,
      decreasedValue REAL,
      datetime TEXT DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'NOW'))
    )
  ''');
  }

  Future<int> insertPercentage(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('percentages', row);
  }

  Future<int> insertIncreaseDecrease(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('incordec', row);
  }

  Future<List<Map<String, dynamic>>> queryLatestRows(
      {required String tableName, required int limit}) async {
    Database db = await instance.database;
    return await db.query(
      tableName,
      orderBy: 'datetime DESC',
      limit: 100,
    );
  }

  Future<List<Map<String, dynamic>>> queryLatestIncordecRows(
      {required int limit}) async {
    return await queryLatestRows(tableName: 'incordec', limit: limit);
  }
}
