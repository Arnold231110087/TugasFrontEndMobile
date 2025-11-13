import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_arnold/components/history_component.dart'; 
import '../services/database.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [];
  bool _isLoading = true;
  
  final LocalDatabase _localDb = LocalDatabase();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email'); 

    if (email != null) {
      final data = await _localDb.readHistoryByEmail(email);
      if (mounted) {
        setState(() {
          // Buat salinan list agar bisa dimodifikasi (mutable)
          history = List.from(data);
          _isLoading = false;
        });
      }
    } else {
       if (mounted) {
         setState(() => _isLoading = false);
       }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Hapus Histori"),
          content: const Text("Hapus history pembelian ini?"),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.close),
              label: const Text("Tidak"),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Iya"),
              onPressed: () async {
                final item = history[index];
                final deletedId = item['id'];

                if (deletedId != null) {
                  final deletedRows = await _localDb.deleteHistory(deletedId);

                  if (deletedRows > 0) {
                    Navigator.of(dialogContext).pop(true);
                    setState(() {
                      history.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Histori berhasil dihapus ✅'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.of(dialogContext).pop(false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal menghapus: ID tidak ditemukan ❌'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  Navigator.of(dialogContext).pop(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal menghapus: ID transaksi tidak ditemukan'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Histori',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color ?? Colors.white,
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Belum ada riwayat transaksi.",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Lakukan transaksi pertama Anda sekarang!",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return HistoryComponent(
                    item: item,
                    onDelete: () => _showDeleteConfirmationDialog(context, index),
                  );
                },
              ),
    );
  }
}