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
      version: 4, // <-- 1. NAIKKAN VERSI KE 4
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
        
        // --- 2. TAMBAHKAN TABEL 'history' (DARI 'HistoryDatabase') ---
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
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Ini berjalan untuk pengguna yang sudah ada
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE session (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              activeUid TEXT
            )
          ''');
        }
        
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
        
        // --- 3. TAMBAHKAN LOGIKA UPGRADE UNTUK v4 ---
        if (oldVersion < 4) {
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
        // --- AKHIR TAMBAHAN ---
      },
    );
  }

  // --- FUNGSI UNTUK TABEL 'users' ---
  
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'users',
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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

  // --- FUNGSI UNTUK TABEL 'search_history' ---

  Future<List<Map<String, dynamic>>> getSearchHistory(String uid) async {
    final db = await database;
    return await db.query(
      'search_history',
      where: 'userId = ?',
      whereArgs: [uid],
      orderBy: 'timestamp DESC',
      limit: 5,
    );
  }

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

  Future<void> deleteSearchHistory(String uid, String searchedUid) async {
    final db = await database;
    await db.delete(
      'search_history',
      where: 'userId = ? AND searchedUid = ?',
      whereArgs: [uid, searchedUid],
    );
  }

  Future<void> clearSearchHistory(String uid) async {
    final db = await database;
    await db.delete(
      'search_history',
      where: 'userId = ?',
      whereArgs: [uid],
    );
  }

  // --- 4. FUNGSI BARU DARI 'HistoryDatabase' (UNTUK TABEL 'history') ---

  /// Membuat data transaksi baru di tabel 'history'
  Future<int> createHistory(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('history', data);
  }

  /// Membaca riwayat transaksi berdasarkan email
  Future<List<Map<String, dynamic>>> readHistoryByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'history',
      where: 'email = ?',
      whereArgs: [email],
      orderBy: 'date DESC',
    );
    return result;
  }

  /// Membaca semua riwayat transaksi
  Future<List<Map<String, dynamic>>> readAllHistory() async {
    final db = await database;
    final result = await db.query('history', orderBy: 'date DESC');
    return result;
  }

  /// Menghapus satu riwayat transaksi berdasarkan ID
  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}