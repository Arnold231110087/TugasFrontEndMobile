import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart'; 

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalDatabase _localDb = LocalDatabase();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
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

  Future<UserCredential> register(
      String email, String password, String username) async {
    
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
    
    final userDataMap = {
      'username': lowerUsername,
      'email': email,
      'uid': user.uid,
      'bio': '', 
      'createdAt': Timestamp.now(), 
    };

    try {
      await _firestore.collection('users').doc(user.uid).set(userDataMap);
      
      await _saveUserDataToLocal(userDataMap);

    } catch (e) {
      await user.delete();
      throw Exception("Gagal menyimpan profil: $e");
    }
    
    return userCredential;
  }

  // --- Helper & Fungsi Lain  ---

  Future<void> changePassword(String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'user-not-found', message: 'User null');
    await _auth.signInWithEmailAndPassword(email: user.email!, password: currentPassword);
    await _auth.currentUser!.updatePassword(newPassword);
  }

  Future<void> deleteUserAccount(String currentPassword) async {
    User? user = _auth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'user-not-found', message: 'User null');
    
    await _auth.signInWithEmailAndPassword(email: user.email!, password: currentPassword);
    
    try {
      await _firestore.collection('users').doc(user.uid).delete();
      await _localDb.deleteUser(user.uid); 
    } catch (e) {
      throw Exception("Gagal hapus data: Terjadi Kesalahan. Silahkan ulangi beberapa saat lagi.");
    }
    await _auth.currentUser!.delete(); 
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) { return null; }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<void> updateUserProfileData(String uid, Map<String, dynamic> data) async {
    if (data.containsKey('username')) {
      data['username'] = data['username'].toString().toLowerCase();
    }
    await _firestore.collection('users').doc(uid).update(data);
    
    final updatedUserData = await getUserData(uid);
    if (updatedUserData != null) await _saveUserDataToLocal(updatedUserData);
  }

  Future<void> _saveUserDataToLocal(Map<String, dynamic> userData) async {
    String createdAtString = DateTime.now().toIso8601String();
    if (userData['createdAt'] is Timestamp) {
      createdAtString = (userData['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    await _localDb.saveUser({
      'uid': userData['uid'],
      'email': userData['email'],
      'username': userData['username'],
      'bio': userData['bio'] ?? '',
      'createdAt': createdAtString,
    });
  }
  
  Future<void> saveTransactionHistoryToFirebase(String myUid, Map<String, dynamic> d) async {
     await _firestore.collection('users').doc(myUid).collection('transaction_history').add(d);
  }
  Future<void> saveSearchHistoryToFirebase(String myUid, Map<String, dynamic> d) async {
     if (myUid == d['uid']) return;
     await _firestore.collection('users').doc(myUid).collection('search_history').doc(d['uid']).set(d);
  }
  Future<void> deleteSearchHistoryFromFirebase(String myUid, String sUid) async {
     await _firestore.collection('users').doc(myUid).collection('search_history').doc(sUid).delete();
  }
}