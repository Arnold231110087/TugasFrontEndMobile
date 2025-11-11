import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDatabase _localDb = LocalDatabase();

  // --- 1. OTENTIKASI DASAR ---

  /// Mendapatkan data user yang sedang login saat ini.
  User? get currentUser => _auth.currentUser;

  /// Fungsi untuk Login dengan Email & Password.
  Future<UserCredential> signIn(String email, String password) async {
    // 1. Login ke Firebase
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Ambil user
    final user = userCredential.user;
    if (user != null) {
      // 3. Ambil data user dari Firestore
      final userData = await getUserData(user.uid);

      // 4. Simpan ke SQLite agar bisa diakses offline
      if (userData != null) {
        await _localDb.saveUser({
          'uid': user.uid,
          'email': userData['email'],
          'username': userData['username'],
          'bio': userData['bio'] ?? '',
          'createdAt': userData['createdAt']?.toDate().toString() ??
              DateTime.now().toIso8601String(),
        });
      }
    }

    return userCredential;
  }

  /// Fungsi Register
  Future<UserCredential> register(
      String email, String password, String username) async {
    // 1. Buat akun baru
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    final lowerUsername = username.toLowerCase();
    // 2. Simpan data tambahan ke Firestore
    if (user != null) {
      final userData = {
        'username': lowerUsername,
        'email': email,
        'uid': user.uid,
        'bio': '',
        'createdAt': Timestamp.now(),
      };

      await _firestore.collection('users').doc(user.uid).set(userData);

      // 3. Simpan juga ke SQLite
      await _localDb.saveUser({
        'uid': user.uid,
        'email': email,
        'username': username,
        'bio': '',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    return userCredential;
  }

  /// Fungsi untuk Logout.
  Future<void> signOut() async {
    // Hapus data lokal tapi tetap simpan di SQLite jika mau caching
    await _auth.signOut();
  }

  // --- 2. MANAJEMEN AKUN ---

  /// Ganti Password.
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User tidak ditemukan.');
    }

    final String email = user.email!;

    try {
      // Re-authenticate
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: currentPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }

    await _auth.currentUser!.updatePassword(newPassword);
  }

  /// Hapus akun dari Auth dan Firestore
  Future<void> deleteUserAccount(String currentPassword) async {
    User? user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User tidak ditemukan.');
    }

    final String email = user.email!;
    final String uid = user.uid;

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: currentPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }

    // Hapus data di Firestore
    await _firestore.collection('users').doc(uid).delete();

    // Hapus akun dari Auth
    await _auth.currentUser!.delete();

    // Hapus dari database lokal
    await _localDb.deleteUser(uid);
  }

  // --- 3. OPERASI DATA FIRESTORE ---

  /// Ambil data user dari Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final docSnap = await _firestore.collection('users').doc(uid).get();
      return docSnap.data();
    } catch (e) {
      print("Error mengambil data user: $e");
      return null;
    }
  }

  /// Stream data user realtime
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  /// Update data pengguna
  Future<void> updateUserProfileData(
      String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);

    // Sinkronkan ke SQLite juga
    final currentUserData = await getUserData(uid);
    if (currentUserData != null) {
      await _localDb.saveUser({
        'uid': uid,
        'email': currentUserData['email'],
        'username': currentUserData['username'],
        'bio': currentUserData['bio'] ?? '',
        'createdAt': currentUserData['createdAt']?.toDate().toString() ??
            DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> saveSearchHistoryToFirebase(String myUid, Map<String, dynamic> searchedUserData) async {
    if (myUid == searchedUserData['uid']) return; // Jangan simpan riwayat cari diri sendiri
    
    await _firestore
        .collection('users')
        .doc(myUid)
        .collection('search_history')
        .doc(searchedUserData['uid']) // Gunakan UID hasil cari sbg ID
        .set({
          'username': searchedUserData['username'],
          'searchedUid': searchedUserData['uid'],
          'timestamp': FieldValue.serverTimestamp(),
          // Anda bisa tambahkan data lain seperti 'profileImageUrl'
        });
  }

  /// Menghapus satu item riwayat dari Firestore
  Future<void> deleteSearchHistoryFromFirebase(String myUid, String searchedUid) async {
     await _firestore
        .collection('users')
        .doc(myUid)
        .collection('search_history')
        .doc(searchedUid)
        .delete();
  }

  /// Mengambil riwayat dari Firestore (untuk sinkronisasi saat login)
  Stream<QuerySnapshot<Map<String, dynamic>>> getSearchHistoryStream(String myUid) {
    return _firestore
        .collection('users')
        .doc(myUid)
        .collection('search_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }
}
