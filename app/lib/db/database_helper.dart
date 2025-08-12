import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../models/models.dart';

class DatabaseHelper {

  //Database instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cashier_app.db');

    return await openDatabase(
      path,
      version:
          1, // Si ya tienes una versión, incrementa a 3 para forzar la actualización
      // Code to initialize the database when it does not exist.
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password TEXT NOT NULL
        )
      ''');

        // CAMBIO 1: Añadir el campo fecha_transaccion a la tabla "transaction"
        await db.execute('''
        CREATE TABLE "transaction" (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          precio_total REAL DEFAULT 0,
          cambio REAL DEFAULT 0,
          fecha_transaccion TEXT NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE item (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          transaction_id INTEGER NOT NULL,
          nombre TEXT NOT NULL,
          precio REAL NOT NULL,
          cantidad INTEGER NOT NULL,
          FOREIGN KEY (transaction_id) REFERENCES "transaction"(id) ON DELETE CASCADE
        )
      ''');
      },
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((json) => User.fromMap(json)).toList();
  }

  Future<void> verificarTablasYColumnas() async {
    // Primero obtenemos la instancia de la base de datos de forma correcta
    final db = await DatabaseHelper().database;

    // 1️⃣ Obtener todas las tablas de usuario (ignora las internas de SQLite)
    // Ahora la consulta también escapará los nombres de tablas si es necesario.
    List<Map<String, dynamic>> tablas = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );

    for (var t in tablas) {
      // Escapamos el nombre de la tabla con comillas dobles para que
      // PRAGMA lo reconozca correctamente.
      String nombreTabla = t['name'];
      String nombreTablaEscapado = '"$nombreTabla"';

      print("\n📂 Tabla: $nombreTabla");

      // 2️⃣ Obtener columnas de esa tabla
      // Usamos el nombre de la tabla escapado en la consulta PRAGMA.
      List<Map<String, dynamic>> columnas = await db.rawQuery(
        "PRAGMA table_info($nombreTablaEscapado)",
      );

      for (var col in columnas) {
        print(
          "   📌 ${col['name']} (${col['type']})"
          "${col['notnull'] == 1 ? ' NOT NULL' : ''}"
          "${col['pk'] == 1 ? ' PRIMARY KEY' : ''}",
        );
      }
    }
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

    // Usamos una transacción para asegurarnos de que todo se guarde o nada se guarde.
    await db.transaction((txn) async {
      // 1. Insertamos la transacción principal
      final int transactionId = await txn.insert('"transaction"', {
        'precio_total': transaction.precioTotal,
        'cambio': transaction.cambio,
        'fecha_transaccion': transaction.fechaTransaccion,
      });

      // 2. Insertamos cada ítem con el ID de la transacción principal
      for (var item in transaction.items) {
        await txn.insert('item', {
          'transaction_id': transactionId,
          'nombre': item['name'],
          'precio': item['price'],
          'cantidad': item['quantity'],
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

    String query = '''
    SELECT DISTINCT t.*
    FROM "transaction" t
    LEFT JOIN item i ON t.id = i.transaction_id
    WHERE 1=1
    ''';

    List<dynamic> args = [];

    if (itemName != null && itemName.isNotEmpty) {
      query += ' AND i.nombre LIKE ?';
      args.add('%$itemName%');
    }

    if (date != null && date.isNotEmpty) {
      // CAMBIO 1: Usar el nombre de columna correcto 'fecha_transaccion'
      // y el operador LIKE para buscar por fecha (por ejemplo, '2023-10-27%')
      query += ' AND t.fecha_transaccion LIKE ?';
      args.add('$date%');
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
          // CAMBIO 2: Leer el valor del campo 'fecha_transaccion' del mapa y pasarlo al modelo
          fechaTransaccion: txMap['fecha_transaccion'] as String,
        ),
      );
    }
    return transactions;
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final transactionMaps = await db.query('"transaction"');
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
          // CAMBIO 3: Leer el valor del campo 'fecha_transaccion' del mapa y pasarlo al modelo
          fechaTransaccion: txMap['fecha_transaccion'] as String,
        ),
      );
    }
    return transactions;
  }
}
