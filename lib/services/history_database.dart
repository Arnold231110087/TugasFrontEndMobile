import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryDatabase {
  static final HistoryDatabase instance = HistoryDatabase._init();
  static Database? _database;

  HistoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);

  return await openDatabase(
    path,
    version: 2, // ⬅️ Naikkan versi dari 1 ke 2
    onCreate: _createDB,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('DROP TABLE IF EXISTS history');
        await _createDB(db, newVersion);
      }
    },
  );
  }


  Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT,
      title TEXT,
      description TEXT,
      profile TEXT,
      price INTEGER,
      success INTEGER,
      id_transaksi TEXT,
      date TEXT,
      time TEXT
    )
  ''');
  }

  Future<int> create(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('history', data);
  }

  Future<List<Map<String, dynamic>>> readByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'history',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final db = await instance.database;
    final result = await db.query('history', orderBy: 'date DESC');
    return result;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
