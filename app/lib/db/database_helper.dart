import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cashier_app.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemName TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Eliminamos tabla transaction (ojo con los datos)
          await db.execute('DROP TABLE IF EXISTS transaction');
          // Creamos tabla transaction con nueva estructura
          await db.execute('''
          CREATE TABLE transaction (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            precio_total REAL DEFAULT 0,
            cambio REAL DEFAULT 0
          )
        ''');

          // Creamos tabla item si no existe (o también podrías usar DROP y CREATE si querés resetear)
          await db.execute('''
          CREATE TABLE IF NOT EXISTS item (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            transaction_id INTEGER NOT NULL,
            nombre TEXT NOT NULL,
            precio REAL NOT NULL,
            cantidad INTEGER NOT NULL,
            FOREIGN KEY (transaction_id) REFERENCES transaction(id) ON DELETE CASCADE
          )
        ''');
        }
      },
    );
  }

  // User methods
  Future<int> registerUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Transaction methods
  // Future<int> insertTransaction(TransactionModel transaction) async {
  //   final db = await database;
  //   return await db.insert('transactions', transaction.toMap());
  // }

  Future<void> insertTransactionWithItems(TransactionModel transaction) async {
    final db = await database;

    await db.transaction((txn) async {
      // 1. Insertar la transacción y obtener el id generado
      int transactionId = await txn.insert('transaction', {
        'precio_total': transaction.precioTotal,
        'cambio': transaction.cambio,
      });

      // 2. Insertar los items con el transaction_id
      for (var item in transaction.items) {
        await txn.insert('item', {
          'transaction_id': transactionId,
          'nombre': item['nombre'],
          'precio': item['precio'],
          'cantidad': item['cantidad'],
        });
      }
    });
  }

  // Future<List<TransactionModel>> getTransactions() async {
  //   final db = await database;
  //   final result = await db.query('transactions');
  //   return result.map((json) => TransactionModel.fromMap(json)).toList();
  // }

  Future<List<TransactionModel>> searchTransactions({
    String? itemName,
    String? date,
  }) async {
    final db = await database;

    // Consulta básica para traer IDs de transacciones según filtros
    String query = '''
    SELECT DISTINCT t.*
    FROM transaction t
    LEFT JOIN item i ON t.id = i.transaction_id
    WHERE 1=1
  ''';

    List<dynamic> args = [];

    if (itemName != null) {
      query += ' AND i.nombre LIKE ?';
      args.add('%$itemName%');
    }

    if (date != null) {
      // Asumiendo que la tabla transaction tenga columna fecha en formato texto YYYY-MM-DD
      query += ' AND t.fecha = ?';
      args.add(date);
    }

    final transactionMaps = await db.rawQuery(query, args);

    List<TransactionModel> transactions = [];

    for (var txMap in transactionMaps) {
      final itemMaps = await db.query(
        'item',
        where: 'transaction_id = ?',
        whereArgs: [txMap['id']],
      );

      transactions.add(
        TransactionModel(
          id: txMap['id'] as int?,
          precioTotal: (txMap['precio_total'] as num).toDouble(),
          cambio: (txMap['cambio'] as num).toDouble(),
          items: itemMaps,
        ),
      );
    }

    return transactions;
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    // 1. Traer todas las transacciones
    final transactionMaps = await db.query('transaction');

    List<TransactionModel> transactions = [];

    for (var txMap in transactionMaps) {
      // 2. Traer los items para cada transacción
      final itemMaps = await db.query(
        'item',
        where: 'transaction_id = ?',
        whereArgs: [txMap['id']],
      );

      transactions.add(
        TransactionModel(
          id: txMap['id'] as int?,
          precioTotal: (txMap['precio_total'] as num).toDouble(),
          cambio: (txMap['cambio'] as num).toDouble(),
          items: itemMaps,
        ),
      );
    }

    return transactions;
  }
}
