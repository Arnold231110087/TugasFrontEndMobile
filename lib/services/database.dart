import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io'; 
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 
import 'dart:convert';

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
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = join(await getDatabasesPath(), 'user_data.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 5) {
          await _createTables(db); 
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Tabel Users
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        uid TEXT PRIMARY KEY,
        email TEXT,
        username TEXT,
        bio TEXT,
        createdAt TEXT
      )
    ''');
    // Tabel Session
    await db.execute('''
      CREATE TABLE IF NOT EXISTS session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activeUid TEXT
      )
    ''');
    // Tabel Riwayat Pencarian
    await db.execute('''
      CREATE TABLE IF NOT EXISTS search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        searchedUid TEXT,
        username TEXT,
        timestamp INTEGER
      )
    ''');
    // Tabel Riwayat Transaksi
    await db.execute('''
      CREATE TABLE IF NOT EXISTS history (
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
    // Tabel Postingan
    await db.execute('''
      CREATE TABLE IF NOT EXISTS posts (
        id TEXT PRIMARY KEY,
        uid TEXT,
        email TEXT,
        username TEXT,
        time TEXT,
        message TEXT,
        logos TEXT, 
        profileImage TEXT,
        likeCount INTEGER,
        commentCount INTEGER,
        timestamp INTEGER
      )
    ''');
  }

  // --- Users ---
  Future<void> saveUser(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert('users', userData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    final db = await database;
    final result = await db.query('users', where: 'uid = ?', whereArgs: [uid]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> deleteUser(String uid) async {
    final db = await database;
    await db.delete('users', where: 'uid = ?', whereArgs: [uid]);
  }

  // --- Search History ---
  Future<List<Map<String, dynamic>>> getSearchHistory(String uid) async {
    final db = await database;
    return await db.query('search_history', where: 'userId = ?', whereArgs: [uid], orderBy: 'timestamp DESC', limit: 5);
  }

  Future<void> addSearchHistory(Map<String, dynamic> item) async {
    final db = await database;
    await db.delete('search_history', where: 'userId = ? AND searchedUid = ?', whereArgs: [item['userId'], item['searchedUid']]);
    await db.insert('search_history', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteSearchHistory(String uid, String searchedUid) async {
    final db = await database;
    await db.delete('search_history', where: 'userId = ? AND searchedUid = ?', whereArgs: [uid, searchedUid]);
  }

  // --- Transaction History ---
  Future<int> createHistory(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('history', data);
  }

  Future<List<Map<String, dynamic>>> readHistoryByEmail(String email) async {
    final db = await database;
    return await db.query('history', where: 'email = ?', whereArgs: [email], orderBy: 'date DESC');
  }

  Future<int> deleteHistory(int id) async {
    final db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  // --- Posts ---
  Future<void> cachePosts(List<Map<String, dynamic>> posts) async {
    final db = await database;
    final batch = db.batch();
    for (var post in posts) {
      String logosString = jsonEncode(post['logos'] ?? []);
      batch.insert('posts', {
        'id': post['id'],
        'uid': post['uid'],
        'email': post['email'],
        'username': post['username'],
        'time': post['time'],
        'message': post['message'],
        'logos': logosString,
        'profileImage': post['profileImage'],
        'likeCount': post['likeCount'] ?? 0,
        'commentCount': post['commentCount'] ?? 0,
        'timestamp': post['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getUserPosts(String email) async {
    final db = await database;
    final result = await db.query('posts', where: 'email = ?', whereArgs: [email], orderBy: 'timestamp DESC');
    return result.map((row) {
      return {
        'id': row['id'],
        'uid': row['uid'],
        'username': row['username'],
        'email': row['email'],
        'time': row['time'],
        'message': row['message'],
        'logos': jsonDecode(row['logos'] as String),
        'profileImage': row['profileImage'],
        'like': row['likeCount'],
        'comment': row['commentCount'],
        'timestamp': row['timestamp'],
      };
    }).toList();
  }
}