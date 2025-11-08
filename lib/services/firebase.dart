import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- 1. OTENTIKASI DASAR ---

  /// Mendapatkan data user yang sedang login saat ini.
  User? get currentUser => _auth.currentUser;

  /// Fungsi untuk Login dengan Email & Password.
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// (Versi Sederhana) Fungsi register 1 langkah
  /// TIDAK mengecek keunikan username
  Future<UserCredential> register(
      String email, String password, String username) async {
    
    // 1. Buat user di Firebase Authentication
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    // 2. Simpan data tambahan di Cloud Firestore
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
        'uid': user.uid,
        'bio': '', 
        'createdAt': Timestamp.now(), 
      });
    }
    return userCredential;
  }

  /// Fungsi untuk Logout.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- 2. MANAJEMEN AKUN ---

  /// Fungsi untuk Ganti Password.
  // Di file lib/services/auth_service.dart

  /// (Versi Alternatif) Ganti Password menggunakan SIGN-IN (bukan RE-AUTH)
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User tidak ditemukan.');
    }

    final String email = user.email!;

    try {
      // 1. Lakukan SIGN IN (bukan RE-AUTH)
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: currentPassword,
      );
    } on FirebaseAuthException catch(e) {
      // Password salah
      throw e;
    }
    
    // 2. SEGERA ganti password
    // (Gunakan _auth.currentUser! karena kita baru login)
    await _auth.currentUser!.updatePassword(newPassword);
  }

  /// (Versi Sederhana) Menghapus akun pengguna dari Auth dan Firestore.
  Future<void> deleteUserAccount(String currentPassword) async {
    User? user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User tidak ditemukan.');
    }

    // 1. Simpan email dan UID
    final String email = user.email!;
    final String uid = user.uid; 

    try {
      // 2. Lakukan SIGN IN (bukan RE-AUTH)
      // Ini akan me-refresh token dan membuktikan kepemilikan.
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: currentPassword,
      );
    } on FirebaseAuthException catch (e) {
      // Jika password salah, lempar error
      throw e; 
    }

    // 3. SEGERA Hapus data Firestore
    // (User sekarang 'user' yang baru login, tapi UID-nya sama)
    await _firestore.collection('users').doc(uid).delete();
    
    // 4. SEGERA Hapus akun Auth
    // Ini sekarang akan berhasil karena kita baru saja login.
    await _auth.currentUser!.delete(); 
  }

  // --- 3. OPERASI DATA FIRESTORE ---

  /// Mengambil data user (username, bio, dll) dari Firestore.
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final docSnap = await _firestore.collection('users').doc(uid).get();
      return docSnap.data();
    } catch (e) {
      print("Error mengambil data user: $e");
      return null;
    }
  }

  /// Mengambil STREAM data user (username, bio, dll) dari Firestore.
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  /// (Versi Sederhana) Meng-update data pengguna
  /// TIDAK mengecek keunikan username
  Future<void> updateUserProfileData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}