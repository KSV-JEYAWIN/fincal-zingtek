import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fincal/vat/vatModel.dart';
import 'package:intl/intl.dart';

class DBHelper {
  DBHelper._(); // Private constructor to prevent instantiation

  static final DBHelper instance = DBHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'vat_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE VATData(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        netPrice REAL,
        vatPercentage REAL,
        vatAmount REAL,
        totalPrice REAL,
        dateTime TEXT
      )
    ''');
  }

  Future<int> insertVATData(VATData data) async {
    final db = await database;
    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    data.dateTime = dateTime;
    return await db.insert('VATData', data.toMap());
  }

  Future<List<VATData>> getVATDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> dataList = await db.query(
      'VATData',
      orderBy: 'dateTime DESC',
      limit: 100,
    );
    return dataList.map((data) => VATData.fromMap(data)).toList();
  }

  // Method to delete VAT data from the database
  Future<void> deleteVATData(int id) async {
    final db = await database;
    await db.delete(
      'VATData',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
