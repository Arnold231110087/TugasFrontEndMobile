import 'package:flutter/material.dart';
import 'package:mobile_arnold/services/firebase.dart';
import '../utils/rupiah_format.dart';
import 'payment_success_page.dart';
import '../services/database.dart'; 
import '../components/payment_option.dart';

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
  
  final LocalDatabase _localDb = LocalDatabase();
  final AuthService _authService = AuthService();

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
                  
                  final user = _authService.currentUser;

                  if (user == null || user.email == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error: Pengguna tidak ditemukan. Silakan login ulang.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final String email = user.email!;
                  final String uid = user.uid;

                  final newHistory = {
                    'email': email,
                    'title': 'Pembayaran Berhasil',
                    'description': 'Pembelian logo dengan metode $selectedPayment',
                    'profile': 'assets/images/profile1.png',
                    'price': widget.amount,
                    'success': 1,
                    'id_transaksi': now.millisecondsSinceEpoch.toString(),
                    'date': '${now.day}-${now.month}-${now.year}',
                    'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
                  };

                  try {
                    // Simpan ke Cache SQFlite
                    await _localDb.createHistory(newHistory);

                    // Simpan ke Firebase Firestore
                    await _authService.saveTransactionHistoryToFirebase(uid, newHistory);

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentSuccessPage(),
                        ),
                      );
                    }
                  } catch (e) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menyimpan transaksi: $e'),
                        backgroundColor: Colors.red,
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