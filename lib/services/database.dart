import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  factory LocalDatabase() => _instance;
  LocalDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'user_data.db');

    return await openDatabase(
      path,
      version: 2, // ⬅️ Ubah dari 1 ke 2
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            uid TEXT PRIMARY KEY,
            email TEXT,
            username TEXT,
            bio TEXT,
            createdAt TEXT
          )
        ''');

        // 🔹 Tambahkan tabel session baru
        await db.execute('''
          CREATE TABLE session (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            activeUid TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // 🔹 Kalau database lama belum punya tabel session, tambahkan
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE session (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              activeUid TEXT
            )
          ''');
        }
      },
    );
  }

  /// Simpan data user setelah login atau register dari Firebase
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'users',
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Ambil data user berdasarkan UID (digunakan oleh AuthService)
  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// Ambil email user yang sedang login
  Future<String?> getCurrentUserEmail() async {
    final db = await database;
    final result = await db.query('users', limit: 1);
    if (result.isNotEmpty) {
      return result.first['email'] as String?;
    }
    return null;
  }

  Future<void> deleteUser(String uid) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }

  Future<void> clearLocalData() async {
    final db = await database;
    await db.delete('users');
  }
}
