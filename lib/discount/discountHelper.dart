import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'discountmodel.dart';

class DiscountDatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'discount_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE discounts(
        id INTEGER PRIMARY KEY,
        originalPrice REAL,
        discountPercentage REAL,
        discountedPrice REAL,
        amountSaved REAL,
        dateTime TEXT
      )
      ''');
  }

  Future<List<Discount>> getDiscountHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'discounts',
      orderBy: 'dateTime DESC',
      limit: 100, // Limit to the latest 100 records
    );
    return List.generate(maps.length, (i) {
      return Discount.fromMap(maps[i]);
    });
  }

  Future<int> insertDiscount(Discount discount) async {
    final db = await database;
    return await db.insert('discounts', discount.toMap());
  }
}
