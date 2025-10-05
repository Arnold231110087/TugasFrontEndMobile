import 'package:flutter/material.dart';
import 'package:mobile_arnold/components/history_component.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> history = [
    {
      'title': 'Jonathan Joestar',
      'description': 'Pembelian Logo bca',
      'profile': 'assets/images/profile1.png',
      'price': 32000,
      'success': true,
      "id_transaksi": "202505141129",
      'date': '14 Mei 2025',
      'time': '12:01',
    },
    {
      'title': 'Kujo Jotaro',
      'description': 'Pembelian Logo pertamina',
      'success': true,
      "id_transaksi": "202506120972",
      'profile': 'assets/images/profile1.png',
      'price': 82500,
      'date': '12 Juni 2025',
      'time': '19:41',
    },
  ];

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
              onPressed: () {
                setState(() {
                  history.removeAt(index);
                });
                Navigator.of(dialogContext).pop(true);
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
      body:
          history.isEmpty
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
                    onDelete:
                        () => _showDeleteConfirmationDialog(context, index),
                  );
                },
              ),
    );
  }
}
