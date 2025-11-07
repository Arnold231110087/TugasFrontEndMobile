import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- 1. OTENTIKASI DASAR ---

  /// Mendapatkan data user yang sedang login saat ini.
  User? get currentUser => _auth.currentUser;

  /// Fungsi untuk Login dengan Email & Password.
  /// Melempar error jika login gagal.
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Fungsi untuk Register User baru.
  /// Otomatis menyimpan 'username' dan 'email' ke Firestore.
  Future<UserCredential> register(
      String email, String password, String username) async {
    // 1. Buat user di Firebase Authentication
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      // 2. Simpan data tambahan di Cloud Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
        'uid': user.uid,
        'createdAt': Timestamp.now(), // Opsional
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
  /// Memerlukan re-autentikasi (password lama).
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    
    // Validasi user
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User tidak ditemukan.');
    }

    // 1. Dapatkan kredensial dengan password lama
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    // 2. Re-autentikasi user
    await user.reauthenticateWithCredential(credential);

    // 3. Jika sukses, update password baru
    await user.updatePassword(newPassword);
  }

  /// Menghapus akun pengguna dari Auth dan Firestore.
  /// Memerlukan re-autentikasi (password lama).
  Future<void> deleteUserAccount(String currentPassword) async {
    User? user = _auth.currentUser;

    if (user == null || user.email == null) {
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User tidak ditemukan.');
    }

    // 1. Dapatkan kredensial
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    // 2. Re-autentikasi
    await user.reauthenticateWithCredential(credential);

    // 3. Hapus data dari Firestore (Lakukan ini dulu)
    await _firestore.collection('users').doc(user.uid).delete();

    // 4. Hapus user dari Firebase Auth (Terakhir)
    await user.delete();
  }

  // --- 3. OPERASI DATA FIRESTORE ---

  /// Mengambil data user (username, bio, dll) dari Firestore.
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final docSnap = await _firestore.collection('users').doc(uid).get();
      return docSnap.data();
    } catch (e) {
      // Handle error jika user tidak ada di firestore tapi ada di auth, dsb.
      print("Error mengambil data user: $e");
      return null;
    }
  }

  /// Meng-update data pengguna di koleksi 'users' di Firestore.
  /// 'data' adalah Map, contoh: {'username': 'nama_baru', 'bio': 'Tentang saya...'}
  Future<void> updateUserProfileData(String uid, Map<String, dynamic> data) async {
    // Gunakan 'update' untuk mengubah field, 'set' dengan merge:true juga bisa
    await _firestore.collection('users').doc(uid).update(data);
  }
}