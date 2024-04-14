import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tipmodel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'tips_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE tips(id INTEGER PRIMARY KEY AUTOINCREMENT, bill_amount REAL, tip_percentage REAL, number_of_persons INTEGER, tip_amount REAL, total_amount REAL, amount_per_person REAL, datetime TEXT DEFAULT CURRENT_TIMESTAMP)');
  }

  Future<int> insertTip(Tip tip) async {
    Database db = await database;
    return await db.insert('tips', tip.toMap());
  }

  Future<List<Tip>> getAllTips() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'tips',
      orderBy: 'datetime DESC',
      limit: 100, // Limit to the latest 100 records
    );
    return result.map((e) => Tip.fromMap(e)).toList();
  }

  Future<int> deleteTip(int id) async {
    Database db = await database;
    return await db.delete('tips', where: 'id = ?', whereArgs: [id]);
  }
}
