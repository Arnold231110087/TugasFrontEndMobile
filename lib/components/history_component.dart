import 'package:flutter/material.dart';
import '../utils/rupiah_format.dart';

class HistoryComponent extends StatelessWidget {
  final Map item;
  final VoidCallback? onDelete;

  const HistoryComponent({super.key, required this.item, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            titleAlignment: ListTileTitleAlignment.center,
            leading: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                radius: 24, // Sedikit lebih besar
                child: const Icon(Icons.check, size: 30, color: Colors.green),
              ),
            ),
            title: Text(
              item['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['description'],
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['date']} ${item['time']}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                if (item.containsKey('id_transaksi')) // Tampilkan ID jika ada
                  Text(
                    'ID Transaksi: ${item['id_transaksi']}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  ),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              print('Item ${item['title']} diklik!');
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rupiahFormat(item['price']),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
