import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDatabase _localDb = LocalDatabase();

  // --- OTENTIKASI DASAR ---

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final user = userCredential.user;
    if (user != null) {
      // Sinkronisasi data ke lokal saat login
      final userData = await getUserData(user.uid);
      if (userData != null) {
        await _saveUserDataToLocal(userData);
      }
    }
    return userCredential;
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Register dengan validasi username unik via Transaksi
  Future<UserCredential> register(
      String email, String password, String username) async {
    
    // 1. Buat user Auth
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e; 
    }

    User? user = userCredential.user;
    if (user == null) {
      throw Exception("Gagal membuat user, user null.");
    }

    final String lowerUsername = username.toLowerCase();
    final userRef = _firestore.collection('users').doc(user.uid);
    final usernameRef = _firestore.collection('usernames').doc(lowerUsername);

    final userDataMap = {
      'username': lowerUsername,
      'email': email,
      'uid': user.uid,
      'bio': '', 
      'createdAt': Timestamp.now(), 
    };

    // 2. Transaksi Simpan Data & Reservasi Username
    try {
      await _firestore.runTransaction((transaction) async {
        // Reservasi nama di koleksi 'usernames'
        transaction.set(usernameRef, {'uid': user.uid}); 
        // Simpan profil di koleksi 'users'
        transaction.set(userRef, userDataMap);
      });
      
      // 3. Simpan ke SQFlite
      await _saveUserDataToLocal(userDataMap);

    } catch (e) {
      // Cek error dari Security Rules (username sudah ada)
      if (e is FirebaseException && (e.code == 'permission-denied' || e.code == 'PERMISSION_DENIED')) {
        throw FirebaseAuthException(
          code: 'username-already-in-use',
          message: 'Nama pengguna ini sudah terdaftar.',
        );
      }
      throw Exception("Transaksi gagal: $e"); 
    }
    
    return userCredential;
  }

  // --- MANAJEMEN AKUN ---

  /// Ganti Password menggunakan signIn (Anti-Stuck Windows)
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(code: 'user-not-found', message: 'User tidak ditemukan.');
    }
    
    try {
      await _auth.signInWithEmailAndPassword(email: user.email!, password: currentPassword);
    } on FirebaseAuthException catch(e) {
      throw e;
    }
    await _auth.currentUser!.updatePassword(newPassword);
  }

  /// Hapus Akun menggunakan signIn (Anti-Stuck Windows)
  Future<void> deleteUserAccount(String currentPassword) async {
    User? user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(code: 'user-not-found', message: 'User tidak ditemukan.');
    }

    final String email = user.email!;
    final String uid = user.uid; 

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: currentPassword);
    } on FirebaseAuthException catch (e) {
      throw e; 
    }

    User? loggedInUser = _auth.currentUser;
    if (loggedInUser == null || loggedInUser.uid != uid) {
      throw Exception("Gagal memverifikasi ulang user.");
    }
    
    // Hapus data Firestore & Reservasi Username
    final userRef = _firestore.collection('users').doc(uid);
    try {
      final userDoc = await userRef.get();
      final username = userDoc.data()?['username'];
      
      final batch = _firestore.batch();
      batch.delete(userRef); 

      if (username != null && username.isNotEmpty) {
        final usernameRef = _firestore.collection('usernames').doc(username);
        batch.delete(usernameRef); 
      }
      await batch.commit();
      
      // Hapus data lokal
      await _localDb.deleteUser(uid); 
    } catch (e) {
      throw Exception("Gagal menghapus data Firestore: $e");
    }
    
    await loggedInUser.delete(); 
  }

  // --- OPERASI DATA ---

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final docSnap = await _firestore.collection('users').doc(uid).get();
      return docSnap.data();
    } catch (e) {
      return null;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  /// Simpan riwayat transaksi ke Firestore
  Future<void> saveTransactionHistoryToFirebase(
      String myUid, Map<String, dynamic> historyData) async {
    final firestoreData = Map<String, dynamic>.from(historyData);
    firestoreData['serverTimestamp'] = FieldValue.serverTimestamp();

    await _firestore
        .collection('users')
        .doc(myUid)
        .collection('transaction_history')
        .add(firestoreData);
  }

  /// Simpan riwayat pencarian ke Firestore
  Future<void> saveSearchHistoryToFirebase(String myUid, Map<String, dynamic> searchedUserData) async {
    if (myUid == searchedUserData['uid']) return;
    
    await _firestore
        .collection('users')
        .doc(myUid)
        .collection('search_history')
        .doc(searchedUserData['uid']) 
        .set({
          'username': searchedUserData['username'],
          'searchedUid': searchedUserData['uid'],
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Future<void> deleteSearchHistoryFromFirebase(String myUid, String searchedUid) async {
     await _firestore
        .collection('users')
        .doc(myUid)
        .collection('search_history')
        .doc(searchedUid)
        .delete();
  }

  /// Update profil dengan validasi username unik via Transaksi
  Future<void> updateUserProfileData(String uid, Map<String, dynamic> data) async {
    
    if (data.containsKey('username')) {
      data['username'] = data['username'].toString().toLowerCase();
    }
    
    if (!data.containsKey('username')) {
      await _firestore.collection('users').doc(uid).update(data);
    } else {
      final newUsername = data['username'];
      final userRef = _firestore.collection('users').doc(uid);

      final oldUserDoc = await userRef.get();
      if (!oldUserDoc.exists) throw Exception("Dokumen user tidak ditemukan.");
      
      final oldUsername = oldUserDoc.data()?['username'];
      
      // Jika username sama, update biasa
      if (oldUsername == newUsername) {
         final dataToUpdate = Map<String, dynamic>.from(data);
         dataToUpdate.remove('username');
         if (dataToUpdate.isNotEmpty) await userRef.update(dataToUpdate);
      } else {
        // Jika username beda, cek keunikan
        final newUsernameRef = _firestore.collection('usernames').doc(newUsername);
        
        await _firestore.runTransaction((transaction) async {
          final newUsernameDoc = await transaction.get(newUsernameRef);
          if (newUsernameDoc.exists) {
            throw FirebaseAuthException(
              code: 'username-already-in-use',
              message: 'Nama pengguna ini sudah terdaftar.',
            );
          }
          
          if (oldUsername != null && oldUsername.isNotEmpty) {
            final oldUsernameRef = _firestore.collection('usernames').doc(oldUsername);
            transaction.delete(oldUsernameRef);
          }
          transaction.set(newUsernameRef, {'uid': uid});
          transaction.update(userRef, data);
        });
      }
    }

    // Sinkronkan ke Lokal
    final updatedUserData = await getUserData(uid);
    if (updatedUserData != null) {
      await _saveUserDataToLocal(updatedUserData);
    }
  }

  // Helper: Simpan ke SQFlite
  Future<void> _saveUserDataToLocal(Map<String, dynamic> userData) async {
    String createdAtString;
    if (userData['createdAt'] is Timestamp) {
      createdAtString = (userData['createdAt'] as Timestamp).toDate().toIso8601String();
    } else if (userData['createdAt'] is String) {
      createdAtString = userData['createdAt'];
    } else {
      createdAtString = DateTime.now().toIso8601String();
    }

    await _localDb.saveUser({
      'uid': userData['uid'],
      'email': userData['email'],
      'username': userData['username'],
      'bio': userData['bio'] ?? '',
      'createdAt': createdAtString,
    });
  }
}