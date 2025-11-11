import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io'; 
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 


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
    
    // Inisialisasi FFI untuk Windows/Linux/MacOS
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = join(await getDatabasesPath(), 'user_data.db');

    return await openDatabase(
      path,
      version: 3, // <-- 1. NAIKKAN VERSI KE 3
      onCreate: (db, version) async {
        // Ini berjalan untuk instalasi baru
        await db.execute('''
          CREATE TABLE users (
            uid TEXT PRIMARY KEY,
            email TEXT,
            username TEXT,
            bio TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE session (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            activeUid TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE search_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            searchedUid TEXT,
            username TEXT,
            timestamp INTEGER
          )
        ''');
      },
      // --- 2. 'onUpgrade' SEKARANG AKTIF ---
      onUpgrade: (db, oldVersion, newVersion) async {
        // Ini berjalan untuk pengguna yang sudah ada
        if (oldVersion < 2) {
          // Pengguna dari v1 akan mendapatkan 'session'
          await db.execute('''
            CREATE TABLE session (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              activeUid TEXT
            )
          ''');
        }
        
        // --- 3. TAMBAHKAN BLOK 'if' BARU INI ---
        // Pengguna dari v1 DAN v2 akan mendapatkan 'search_history'
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE search_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId TEXT,
              searchedUid TEXT,
              username TEXT,
              timestamp INTEGER
            )
          ''');
        }
        // --- AKHIR TAMBAHAN ---
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

  // --- FUNGSI-FUNGSI BARU UNTUK RIWAYAT PENCARIAN ---

  /// Mengambil riwayat pencarian lokal dari SQFlite
  Future<List<Map<String, dynamic>>> getSearchHistory(String uid) async {
    final db = await database;
    return await db.query(
      'search_history',
      where: 'userId = ?',
      whereArgs: [uid],
      orderBy: 'timestamp DESC',
      limit: 5, // Ambil 5 terakhir
    );
  }

  /// Menyimpan satu item riwayat pencarian ke SQFlite
  Future<void> addSearchHistory(Map<String, dynamic> historyItem) async {
    final db = await database;
    await db.delete(
      'search_history',
      where: 'userId = ? AND searchedUid = ?',
      whereArgs: [historyItem['userId'], historyItem['searchedUid']],
    );
    await db.insert(
      'search_history',
      historyItem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Menghapus satu item riwayat dari SQFlite
  Future<void> deleteSearchHistory(String uid, String searchedUid) async {
    final db = await database;
    await db.delete(
      'search_history',
      where: 'userId = ? AND searchedUid = ?',
      whereArgs: [uid, searchedUid],
    );
  }

  /// Menghapus semua riwayat lokal untuk user
  Future<void> clearSearchHistory(String uid) async {
    final db = await database;
    await db.delete(
      'search_history',
      where: 'userId = ?',
      whereArgs: [uid],
    );
  }
}