import 'package:flutter/material.dart';
import '../components/policy_item_component.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  final List<Map<String, dynamic>> policies = const [
    {
      'icon': Icons.privacy_tip_outlined,
      'title': 'Privasi Terjamin',
      'description': 'Kami menghargai dan melindungi data pribadi setiap pengguna.'
    },
    {
      'icon': Icons.security_outlined,
      'title': 'Keamanan Transaksi',
      'description': 'Semua transaksi dicatat dan diawasi demi transparansi dan keamanan.'
    },
    {
      'icon': Icons.content_copy,
      'title': 'Anti Plagiarisme',
      'description': 'Pengguna dilarang keras menyalin karya orang lain tanpa izin.'
    },
    {
      'icon': Icons.gavel_outlined,
      'title': 'Sanksi Pelanggaran',
      'description': 'Kami berhak menindak pengguna yang melanggar ketentuan layanan.'
    },
    {
      'icon': Icons.lock_outline,
      'title': 'Standar Keamanan Tinggi',
      'description': 'Data tersimpan dengan enkripsi dan standar keamanan modern.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ketentuan dan Kebijakan'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: policies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final policy = policies[index];
          return PolicyItem(
            icon: policy['icon'],
            title: policy['title'],
            description: policy['description'],
          );
        },
      ),
    );
  }
}
