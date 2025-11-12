import 'package:flutter/material.dart';
import '../utils/rupiah_format.dart';
import 'payment_success_page.dart';
// import '../services/history_database.dart'; // <-- HAPUS INI
import '../services/database.dart'; // <-- INI SUDAH BENAR (File gabungan)
import '../services/firebase.dart'; // <-- 1. TAMBAHKAN IMPORT AUTHSERVICE
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
  
  // --- 2. TAMBAHKAN INSTANCE SERVICE ---
  final LocalDatabase _localDb = LocalDatabase();
  final AuthService _authService = AuthService();
  // --- AKHIR TAMBAHAN ---

  // Hapus _getUserEmail(), kita akan ambil langsung dari authService

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Map<String, String>> options = widget.options;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // ... (AppBar Anda tetap sama)
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
                    // ... (Text Style Anda tetap sama)
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
                // --- 3. PERBARUI LOGIKA 'onPressed' ---
                onPressed: () async {
                  final now = DateTime.now();
                  
                  // Ambil user yang sedang login dari AuthService
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
                    'email': email, // Simpan berdasarkan email (sesuai skema lokal)
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
                    // 1. Simpan ke Cache SQFlite
                    // (Gunakan fungsi dari file database.dart gabungan Anda)
                    await _localDb.createHistory(newHistory);

                    // 2. Simpan ke Firebase Firestore
                    await _authService.saveTransactionHistoryToFirebase(uid, newHistory);

                    // 3. Navigasi jika sukses
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
                // --- AKHIR PERUBAHAN ---
                child: const Text('Bayar'),
              ),
            ),
        ],
      ),
    );
  }
}