import 'package:flutter/material.dart';
import '../utils/rupiah_format.dart';
import 'payment_success_page.dart';
import '../services/history_database.dart';
import '../components/payment_option.dart';
import '../services/database.dart'; // 🔹 Tambahkan ini agar bisa ambil email dari LocalDatabase

class PaymentPage extends StatefulWidget {
  final List<Map<String, String>> options;
  final int amount;

  const PaymentPage({
    super.key,
    required this.options,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _BankPageState();
}

class _BankPageState extends State<PaymentPage> {
  String selectedPayment = '';

  Future<String?> _getUserEmail() async {
    final user = await LocalDatabase().getCurrentUserEmail();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Map<String, String>> options = widget.options;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'METODE PEMBAYARAN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: ListView(
                children: [
                  Text(
                    rupiahFormat(widget.amount),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: theme.textTheme.headlineLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...options.expand<Widget>((option) => [
                    PaymentOption(
                      isSelected: option['name'] == selectedPayment,
                      name: option['name']!,
                      icon: option['icon']!,
                      url: option['url']!,
                      onTap: () {
                        setState(() {
                          if (option['name'] == selectedPayment) {
                            selectedPayment = '';
                          } else {
                            selectedPayment = option['name']!;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ]).toList()
                    ..removeLast(),
                ],
              ),
            ),
          ),
          if (selectedPayment.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final email = await _getUserEmail(); // 🔹 Ambil email user aktif

                  if (email == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email pengguna tidak ditemukan.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final newHistory = {
                    'email': email, // 🔹 Simpan berdasarkan email user
                    'title': 'Pembayaran Berhasil',
                    'description': 'Pembelian logo dengan metode $selectedPayment',
                    'profile': 'assets/images/profile1.png',
                    'price': widget.amount,
                    'success': 1,
                    'id_transaksi': now.millisecondsSinceEpoch.toString(),
                    'date': '${now.day}-${now.month}-${now.year}',
                    'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
                  };

                  await HistoryDatabase.instance.create(newHistory);

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentSuccessPage(),
                      ),
                    );
                  }
                },
                child: const Text('Bayar'),
              ),
            ),
        ],
      ),
    );
  }
}
