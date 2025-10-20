import 'package:flutter/material.dart';
import 'package:mobile_arnold/pages/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database.dart';


class DeleteAccountSection extends StatefulWidget {
  const DeleteAccountSection({
    super.key
  });
  
  @override
  State < DeleteAccountSection > createState() => _DeleteAccountSectionState();
}

class _DeleteAccountSectionState extends State < DeleteAccountSection > {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHelper db = DatabaseHelper(); 

  bool _confirmed = false;

   _delAcc() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final result = await db.deleteAccount(email!);
    return result;
  }

  void _showDeleteDialog() {
  // Clear controller dan reset state _confirmed sebelum membuka dialog
  _controller.clear();
  setState(() {
    _confirmed = false;
  });

  showDialog(
    context: context,
    // Gunakan Builder untuk membangun konten dialog
    builder: (BuildContext context) {
      // Gunakan StatefulBuilder untuk mengelola state internal dialog
      return StatefulBuilder(
        builder: (context, setInnerState) { // <-- setInnerState adalah setState lokal untuk dialog
          
          // Deklarasi isConfirmedLokal yang akan digunakan dialog
          bool isConfirmedLokal = _controller.text.trim().toUpperCase() == "HAPUS AKUN";

          return AlertDialog(
            title: const Text("Konfirmasi Hapus Akun"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Anda yakin ingin menghapus akun? Tindakan ini tidak bisa dibatalkan."),
                const SizedBox(height: 16),
                const Text("Ketik: HAPUS AKUN", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  onChanged: (value) {
                    // Panggil setInnerState() untuk me-rebuild AlertDialog
                    setInnerState(() {
                      // Di sini, kita hanya memperbarui _confirmed di class utama
                      // Perubahan ini akan segera terlihat di dialog karena setInnerState dipanggil
                      _confirmed = value.trim().toUpperCase() == "HAPUS AKUN";
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tulis di sini...',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                // Gunakan isConfirmedLokal untuk tombol, yang diperbarui oleh setInnerState
                onPressed: isConfirmedLokal
                    ? () async {
                        Navigator.pop(context);
                        
                        final result = await _delAcc();
                        
                        // Cek apakah widget masih mounted
                        if (!mounted) return;

                        if (result == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Akun berhasil dihapus")),
                          );
                          // Gunakan pushAndRemoveUntil untuk mengosongkan stack navigasi
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Akun gagal dihapus")),
                          );
                        }
                      }
                    : null,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text("Hapus Akun"),
              ),
            ],
          );
        },
      );
    },
  );
}

// Tambahkan dispose untuk _controller
@override
void dispose() {
  _controller.dispose();
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
              onPressed: _showDeleteDialog,
              child: const Text("Hapus Akun"),
            ),
      ],
    );
  }
}