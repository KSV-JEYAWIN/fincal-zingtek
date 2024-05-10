import 'package:fincal/mortage/mortageModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'mortgage_data';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'mortgage_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              loanAmount REAL,
              interestRate REAL,
              loanDuration REAL,
              monthlyEMI REAL,
              totalAmountPayable REAL,
              interestAmount REAL,
              dateTime TEXT
          )''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertMortgageData(MortgageData data) async {
    final db = await database;
    return await db.insert(tableName, data.toMap());
  }

  Future<List<MortgageData>> getAllMortgageDataOrderedByDateTimeDesc(
      {required int limit}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, orderBy: 'dateTime DESC');
    return List.generate(maps.length, (i) {
      return MortgageData.fromMap(maps[i]);
    });
  }
}
