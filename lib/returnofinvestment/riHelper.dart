import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'riModel.dart';

class DBHelper {
  static Database? _database;
  static const String _tableName = 'investment_data';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  static Future<Database> initializeDatabase() async {
    final String path = join(await getDatabasesPath(), 'investment_data.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          investedAmount REAL,
          amountReturned REAL,
          annualPeriod REAL,
          totalGain REAL,
          returnOfInvestment REAL,
          simpleAnnualGrowthRate REAL,
          dateTime TEXT DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      },
    );
  }

  static Future<int> insertInvestmentData(InvestmentData investmentData) async {
    final db = await database;
    return await db.insert(_tableName, investmentData.toMap());
  }

  static Future<List<InvestmentData>> getInvestmentData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'id DESC',
      limit: 100,
    );

    return List.generate(maps.length, (i) {
      return InvestmentData.fromMap(maps[i]);
    });
  }

  static Future<int> deleteInvestmentData(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
