import 'package:flutter/material.dart';
import 'package:mobile_arnold/pages/auth/login_page.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase.dart'; // Gunakan firebase.dart

class DeleteAccountSection extends StatefulWidget {
  const DeleteAccountSection({super.key});
  
  @override
  State<DeleteAccountSection> createState() => _DeleteAccountSectionState();
}

class _DeleteAccountSectionState extends State<DeleteAccountSection> {
  final AuthService _authService = AuthService(); 
  final TextEditingController _confirmTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; 

  // --- FUNGSI EKSEKUSI (Di luar dialog) ---
  Future<void> _performDeleteAccount(String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Panggil Service
      await _authService.deleteUserAccount(password);
      
      // 2. Bersihkan SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Sukses & Navigasi
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun berhasil dihapus"),
          backgroundColor: Colors.green,
        ),
      );
      
      setState(() { _isLoading = false; }); // Stop loading sebelum navigasi
      
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );

    } on FirebaseAuthException catch (e) {
      setState(() { _isLoading = false; });
      String message = "Gagal hapus akun.";
      if(e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
        message = "Password yang Anda masukkan salah.";
      } else {
        message += " ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _showDeleteDialog() {
    _confirmTextController.clear();
    _passwordController.clear();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            bool isPasswordFilled = _passwordController.text.isNotEmpty;
            bool isTextConfirmed = _confirmTextController.text.trim().toUpperCase() == "HAPUS AKUN";
            bool isButtonEnabled = isPasswordFilled && isTextConfirmed;

            return AlertDialog(
              title: const Text("Konfirmasi Hapus Akun"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tindakan ini tidak bisa dibatalkan."),
                  const SizedBox(height: 16),
                  const Text("Masukkan password Anda:", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    onChanged: (_) => setInnerState(() {}),
                    decoration: const InputDecoration(hintText: 'Password Anda...'),
                  ),
                  const SizedBox(height: 16),
                  const Text("Ketik: HAPUS AKUN", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _confirmTextController,
                    onChanged: (_) => setInnerState(() {}),
                    decoration: const InputDecoration(hintText: 'Tulis di sini...'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                TextButton(
                  onPressed: isButtonEnabled
                      ? () => Navigator.pop(context, _passwordController.text.trim())
                      : null,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Hapus Akun"),
                ),
              ],
            );
          },
        );
      },
    ).then((password) {
      // Jalankan eksekusi setelah dialog tertutup
      if (password != null && password.isNotEmpty) {
        _performDeleteAccount(password);
      }
    });
  }

  @override
  void dispose() {
    _confirmTextController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hapus Akun", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
        const SizedBox(height: 8),
        Text(
          "Jika Anda ingin menghapus akun Anda secara permanen, harap lakukan konfirmasi terlebih dahulu.",
          style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: _isLoading ? null : _showDeleteDialog,
          child: _isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Hapus Akun"),
        ),
      ],
    );
  }
}