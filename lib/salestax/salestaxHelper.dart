import 'package:fincal/salestax/salestaxModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'sales_tax';

  DatabaseHelper._(); // Private constructor

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'sales_tax_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, netPrice REAL, salesTaxRate REAL, salesTaxAmount REAL, totalPrice REAL, datetime TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insertSalesTax(SalesTax salesTax) async {
    final now = DateTime.now(); // Get current date and time
    final formattedDateTime =
        now.toIso8601String(); // Convert to ISO 8601 format
    final Database db = await database;
    await db.insert(
      _tableName,
      {
        'netPrice': salesTax.netPrice,
        'salesTaxRate': salesTax.salesTaxRate,
        'salesTaxAmount': salesTax.salesTaxAmount,
        'totalPrice': salesTax.totalPrice,
        'datetime': formattedDateTime, // Use the formatted date and time
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<SalesTax>> getAllSalesTax() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'datetime DESC', // Sort by datetime in descending order
      limit: 100,
    );
    return List.generate(maps.length, (i) {
      return SalesTax(
        id: maps[i]['id'],
        netPrice: maps[i]['netPrice'],
        salesTaxRate: maps[i]['salesTaxRate'],
        salesTaxAmount: maps[i]['salesTaxAmount'],
        totalPrice: maps[i]['totalPrice'],
        datetime: maps[i]['datetime'],
      );
    });
  }

  static Future<void> deleteSalesTax(int? id) async {
    if (id == null) {
      throw ArgumentError("ID cannot be null");
    }
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
