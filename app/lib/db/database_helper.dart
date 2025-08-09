import 'package:app/models/item.dart';
import 'package:app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cashier_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Transaksi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT,
            quantity INTEGER,
            price REAL,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTransaction(TransactionModel transaction, double change, List<Item> items) async {
    final db = await database;
    await db.insert('Transaksi', transaction.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Transaksi', orderBy: 'date DESC');
    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  Future getUser(String trim, String trim2) async {}

  Future<void> registerUser(User user) async {}
}
