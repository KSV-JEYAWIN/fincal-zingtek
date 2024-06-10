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
        title TEXT,
        x INTEGER,
        y INTEGER,
        increasedValue REAL,
        decreasedValue REAL,
        datetime TEXT DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%f', 'NOW'))
      )
    ''');
  }

  Future<int> insertPercentage(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('percentages', row);
    } catch (e) {
      print('Error inserting into percentages: $e');
      throw Exception('Insert operation failed');
    }
  }

  Future<int> insertIncreaseDecrease(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('incordec', row);
    } catch (e) {
      print('Error inserting into incordec: $e');
      throw Exception('Insert operation failed');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecentPercentageRows({
    required int limit,
  }) async {
    try {
      Database db = await instance.database;
      return await db.query(
        'percentages',
        orderBy: 'datetime DESC',
        limit: limit,
      );
    } catch (e) {
      print('Error querying percentages: $e');
      throw Exception('Query operation failed');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecentIncordecRows({
    required int limit,
  }) async {
    try {
      Database db = await instance.database;
      return await db.query(
        'incordec',
        orderBy: 'datetime DESC',
        limit: limit,
      );
    } catch (e) {
      print('Error querying incordec: $e');
      throw Exception('Query operation failed');
    }
  }

  Future<Map<String, dynamic>?> getIncDecData({
    required String title,
    required int xValue,
    required int yValue,
  }) async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> results = await db.query(
        'incordec',
        where: 'title = ? AND x = ? AND y = ?',
        whereArgs: [title, xValue, yValue],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      print('Error querying incordec: $e');
      throw Exception('Query operation failed');
    }
  }

  Future<int> deleteFromTable(String tableName, int id) async {
    try {
      Database db = await instance.database;
      return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting from $tableName: $e');
      throw Exception('Delete operation failed');
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
