import 'package:flutter/material.dart';
import 'package:mobile_arnold/components/history_component.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Map<String, dynamic>> history = const [
      {
        'title': 'Jonathan Joestar',
        'description': 'Pembelian Logo bca',
        'profile' : 'images/profile1.png',
        'price' : 32000,
        'success': true,
        'date' : '14 Mei 2025',
        'time' : '12:01',
       },
      {
        'title': 'Kujo Jotaro',
        'description': 'Pembelian Logo pertamina {Dibatalkan}',
        'success': false,
        'profile' : 'images/profile1.png',
        'price' : 82500,
        'date' : '12 Juni 2025',
        'time' : '19:41',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Histori',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge?.fontSize,
            color: theme.textTheme.displayLarge?.color,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = history[index];
          return HistoryComponent(
            title: item['title'],
            description: item['description'],
            profile: item['profile'],
            success: item['success'],
            price: item['price'],
            date: item['date'],
            time: item['time'],
          );
        },
      ),
    );
  }
}
