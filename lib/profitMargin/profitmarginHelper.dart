import 'package:fincal/profitMargin/profitmaginModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper instance = DBHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'profit_margin_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE profit_margin(id INTEGER PRIMARY KEY, costPrice REAL, sellingPrice REAL, unitsSold INTEGER, profitAmount REAL, profitPercentage REAL, dateTime TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertProfitMargin(ProfitMargin profitMargin) async {
    final db = await database;
    await db.insert(
      'profit_margin',
      profitMargin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProfitMargin>> getAllProfitMargins() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'profit_margin',
      orderBy: 'dateTime DESC',
    );

    return List.generate(maps.length, (i) {
      return ProfitMargin.fromMap(maps[i]);
    });
  }

  Future<void> deleteProfitMargin(int id) async {
    final db = await database;
    await db.delete(
      'profit_margin',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
