import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- Tambahkan ini untuk format tanggal
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Tambahkan ini
import 'package:mobile_arnold/services/firebase.dart';
import '../components/account_status_component.dart';
import '../components/delete_account_component.dart';

class AccountStatusPage extends StatefulWidget {
  const AccountStatusPage({super.key});

  @override
  State<AccountStatusPage> createState() => _AccountStatusPageState();
}

class _AccountStatusPageState extends State<AccountStatusPage> {
  // 1. Tambahkan AuthService dan UID
  final AuthService _authService = AuthService();
  String? _uid;

  @override
  void initState() {
    super.initState();
    // 2. Ambil UID saat halaman dibuka
    _uid = _authService.currentUser?.uid;
  }

  // 3. Buat fungsi helper untuk format tanggal
  String _formatJoinDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Tanggal bergabung tidak diketahui';
    }
    // Format tanggal menjadi "12 Januari 2025"
    return DateFormat('d MMMM yyyy', 'id_ID').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Akun"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // 4. Bungkus Column dengan StreamBuilder
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _uid != null ? _authService.getUserDataStream(_uid!) : null,
          builder: (context, snapshot) {
            // Tampilkan loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Tampilkan error
            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Gagal memuat status akun'));
            }

            // Jika data ada, ekstrak datanya
            final userData = snapshot.data!.data();
            final String email = userData?['email'] ?? 'Email tidak ditemukan';
            final Timestamp? joinTimestamp = userData?['createdAt'];
            final String joinDate = _formatJoinDate(joinTimestamp);

            // 5. Kembalikan UI dengan data dinamis
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountStatusInfo(
                  joinDate: 'Bergabung sejak: $joinDate',
                  linkedAccount: 'Email: $email',
                ),
                const SizedBox(height: 32),
                const DeleteAccountSection(), // Widget hapus akun Anda
              ],
            );
          },
        ),
      ),
    );
  }
}