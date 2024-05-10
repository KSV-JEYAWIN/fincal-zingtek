import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'compound_interest';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    try {
      return await openDatabase(
        join(await getDatabasesPath(), 'compound_interest.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, principal_amount REAL, interest_rate REAL, time_period REAL, compound_frequency TEXT, compound_interest REAL, datetime TEXT)",
          );
        },
        version: 1,
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  static Future<int> insertCompoundInterest(
      Map<String, dynamic> compoundInterest) async {
    try {
      final Database db = await database;
      final now = DateTime.now();
      final formattedDateTime = now.toIso8601String();
      compoundInterest['datetime'] = formattedDateTime;
      return await db.insert(
        _tableName,
        compoundInterest,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting compound interest: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllCompoundInterest() async {
    try {
      final Database db = await database;
      return await db.query(
        _tableName,
        orderBy: 'datetime DESC',
      );
    } catch (e) {
      print('Error fetching compound interest data: $e');
      rethrow;
    }
  }
}
