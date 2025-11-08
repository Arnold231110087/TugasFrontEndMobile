// import 'package:firebase_auth/firebase_auth.dart'; // <-- TAMBAHKAN INI
// import 'package:flutter/material.dart';
// import 'package:mobile_arnold/services/firebase.dart';
// // Pastikan path ini benar ke AuthService Anda
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../components/input_field_2_component.dart'; // Sesuaikan path

// class CreateProfilePage extends StatefulWidget {
//   const CreateProfilePage({super.key});

//   @override
//   State<CreateProfilePage> createState() => _CreateProfilePageState();
// }

// class _CreateProfilePageState extends State<CreateProfilePage> {
//   final TextEditingController usernameController = TextEditingController();
//   final AuthService _authService = AuthService();
//   bool _isLoading = false; // Loading untuk tombol "Simpan"
//   bool _isVerifying = true; // <-- 1. State loading baru untuk verifikasi awal

//   // --- 2. Tambahkan initState ---
//   @override
//   void initState() {
//     super.initState();
//     _forceTokenRefresh();
//   }

//   // --- 3. Tambahkan fungsi refresh token ---
//   Future<void> _forceTokenRefresh() async {
//     User? user = _authService.currentUser;
//     if (user != null) {
//       try {
//         // Ini akan memaksa sinkronisasi status login Anda
//         await user.getIdToken(true);
//       } catch (e) {
//         // Gagal verifikasi, paksa daftar ulang
//         _showSnack("Gagal memverifikasi sesi: $e", Colors.red);
//         await _authService.signOut();
//         if (mounted) Navigator.pushReplacementNamed(context, '/register');
//         return;
//       }
//     } else {
//       // User null, paksa daftar ulang
//       _showSnack("Sesi tidak ditemukan, silakan daftar ulang.", Colors.red);
//       if (mounted) Navigator.pushReplacementNamed(context, '/register');
//       return;
//     }

//     // Jika semua aman, hentikan loading verifikasi dan tampilkan UI
//     if (mounted) {
//       setState(() {
//         _isVerifying = false;
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     final username = usernameController.text.trim();
//     if (username.length < 3) {
//       _showSnack('Username minimal 3 karakter', Colors.red);
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Panggil fungsi LANGKAH 2: saveUserProfile
//       await _authService.saveUserProfile(username);

//       // --- SUKSES ---
//       final user = _authService.currentUser;
//       if (user != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('is_logged_in', true);
//         await prefs.setString('username', username);
//         await prefs.setString('email', user.email!);
//         await prefs.setString('uid', user.uid);
//         await prefs.setString('bio', ''); // Bio default
//       }
      
//       setState(() => _isLoading = false);
//       if (!mounted) return;
//       // Navigasi ke Halaman Utama
//       Navigator.pushReplacementNamed(context, '/'); 

//     } on FirebaseAuthException catch (e) {
//       setState(() => _isLoading = false);
//       String message = e.message ?? "Terjadi kesalahan";
      
//       if (e.code == 'username-already-in-use') {
//         message = 'Nama pengguna ini sudah diambil, silakan gunakan nama lain.';
//         // Jika username sudah ada, HAPUS akun auth hantu dan paksa daftar ulang
//         await _authService.currentUser?.delete(); // Hapus user saat ini
//         await _authService.signOut();
//         if(mounted) Navigator.pushReplacementNamed(context, '/register');
//       }
//       _showSnack(message, Colors.red);
      
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showSnack("Error: $e", Colors.red);
//     }
//   }

//   void _showSnack(String message, Color color) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Center(
//           // --- 4. Tampilkan loading atau UI berdasarkan _isVerifying ---
//           child: _isVerifying
//               ? const CircularProgressIndicator(color: Colors.white)
//               : SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Satu Langkah Lagi!',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Buat nama pengguna unik Anda.',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       const SizedBox(height: 32),
//                       InputField2(
//                         icon: Icons.person,
//                         hint: 'Nama pengguna',
//                         controller: usernameController,
//                         autofocus: true, 
//                       ),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.blue.shade900,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           // Gunakan _isLoading (untuk tombol)
//                           onPressed: _isLoading ? null : _saveProfile,
//                           child: _isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
//                                 )
//                               : const Text('Simpan & Masuk'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }