// cagrHelper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'cagrModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'cagr_database.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE cagr(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          initialInvestment REAL,
          finalInvestment REAL,
          duration REAL,
          cagr REAL,
          dateTime TEXT
        )
      ''');
      },
    );
    return db;
  }

  Future<int> insertCAGR(CAGRModel cagr) async {
    final db = await database;
    String dateTime = DateTime.now().toIso8601String();
    Map<String, dynamic> data = {
      'initialInvestment': cagr.initialInvestment,
      'finalInvestment': cagr.finalInvestment,
      'duration': cagr.duration,
      'cagr': cagr.cagr,
      'dateTime': dateTime,
    };
    return await db.insert('cagr', data);
  }

  Future<List<CAGRModel>> getCAGRList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cagr',
      orderBy: 'dateTime DESC', // Order by dateTime in descending order
      limit: 100, // Limit to only the latest 100 records
    );
    return List.generate(maps.length, (i) {
      return CAGRModel(
        id: maps[i]['id'],
        initialInvestment: maps[i]['initialInvestment'],
        finalInvestment: maps[i]['finalInvestment'],
        duration: maps[i]['duration'],
        cagr: maps[i]['cagr'],
        dateTime: maps[i]['dateTime'],
      );
    });
  }
}
