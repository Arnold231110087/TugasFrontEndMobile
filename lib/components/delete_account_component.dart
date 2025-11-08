import 'package:flutter/material.dart';
import 'package:mobile_arnold/pages/auth/login_page.dart'; // Sesuaikan path
import 'package:mobile_arnold/services/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountSection extends StatefulWidget {
  const DeleteAccountSection({
    super.key
  });
  
  @override
  State < DeleteAccountSection > createState() => _DeleteAccountSectionState();
}

class _DeleteAccountSectionState extends State < DeleteAccountSection > {
  final AuthService _authService = AuthService(); 
  final TextEditingController _confirmTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State loading HANYA untuk widget utama
  bool _isLoading = false; 

  // 1. FUNGSI ASYNC TERPISAH UNTUK AKSI HAPUS
  Future<void> _performDeleteAccount(String password) async {
    // 1. Mulai loading di state utama
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Panggil service (versi sederhana)
      await _authService.deleteUserAccount(password);
      
      // 3. Hapus data sesi lokal
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 4. Tampilkan sukses & navigasi
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun berhasil dihapus"),
          backgroundColor: Colors.green,
        ),
      );

      // --- PERBAIKAN STUCK LOADING ---
      setState(() { _isLoading = false; }); // Hentikan loading DULU
      if (!mounted) return; // Cek lagi
      Navigator.of(context).pushAndRemoveUntil( // BARU navigasi
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
      // --- AKHIR PERBAIKAN ---

    } on FirebaseAuthException catch (e) {
      // 5. Tangani jika GAGAL (misal: password salah)
      setState(() { _isLoading = false; }); // Hentikan loading
      String message = "Gagal hapus akun: ${e.message}";
      if(e.code == 'wrong-password' || e.code == 'INVALID_LOGIN_CREDENTIALS') {
        message = "Password yang Anda masukkan salah.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // 6. Tangani error lainnya
      setState(() { _isLoading = false; }); // Hentikan loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 2. FUNGSI DIALOG DIPERBARUI
  void _showDeleteDialog() {
    _confirmTextController.clear();
    _passwordController.clear();

    // Dialog sekarang akan mengembalikan 'String' (password) saat ditutup
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // StatefulBuilder masih diperlukan untuk tombol 'Hapus' di dialog
        return StatefulBuilder(
          builder: (context, setInnerState) {
            
            bool isPasswordFilled = _passwordController.text.isNotEmpty;
            bool isTextConfirmed = _confirmTextController.text.trim().toUpperCase() == "HAPUS AKUN";
            // Tombol di dialog hanya perlu cek field
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
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    autofocus: true,
                    onChanged: (value) => setInnerState(() {}), // Update UI dialog
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password Anda...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Ketik: HAPUS AKUN", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmTextController,
                    onChanged: (value) => setInnerState(() {}), // Update UI dialog
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Tulis di sini...',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Hanya tutup dialog
                  child: const Text("Batal"),
                ),
                TextButton(
                  onPressed: isButtonEnabled
                      ? () {
                          // 3. KEMBALIKAN PASSWORD & TUTUP DIALOG
                          Navigator.pop(context, _passwordController.text.trim());
                        }
                      : null, // Tombol nonaktif
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: const Text("Hapus Akun"),
                ),
              ],
            );
          },
        );
      },
    ).then((password) {
      // 4. 'then' DIEKSEKUSI SETELAH DIALOG TERTUTUP
      if (password != null && password.isNotEmpty) {
        // Panggil fungsi async utama di sini
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
        Text("Hapus Akun", style: TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ), ),
        const SizedBox(height: 8),
          Text(
            "Jika Anda ingin menghapus akun Anda secara permanen, harap lakukan konfirmasi terlebih dahulu.",
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              // Tombol utama sekarang dikontrol oleh _isLoading
              onPressed: _isLoading ? null : _showDeleteDialog,
              child: _isLoading 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : const Text("Hapus Akun"),
            ),
      ],
    );
  }
}