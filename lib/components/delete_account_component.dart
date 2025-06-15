import 'package:flutter/material.dart';

class DeleteAccountSection extends StatefulWidget {
  const DeleteAccountSection({
    super.key
  });

  @override
  State < DeleteAccountSection > createState() => _DeleteAccountSectionState();
}

class _DeleteAccountSectionState extends State < DeleteAccountSection > {
  final TextEditingController _controller = TextEditingController();
  bool _confirmed = false;

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
                          setState(() {
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
              onPressed: _confirmed ?
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Akun berhasil dihapus (simulasi).")),
                );
              } :
              null,
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Hapus Akun"),
            ),
          ],
      ),
    );
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