import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_arnold/services/firebase.dart'; 
import '../components/account_status_component.dart';
import '../components/delete_account_component.dart';

class AccountStatusPage extends StatefulWidget {
  const AccountStatusPage({super.key});

  @override
  State<AccountStatusPage> createState() => _AccountStatusPageState();
}

class _AccountStatusPageState extends State<AccountStatusPage> {
  final AuthService _authService = AuthService();
  String? _uid;

  @override
  void initState() {
    super.initState();
    // Ambil UID user yang sedang login
    _uid = _authService.currentUser?.uid;
  }

  /// Helper untuk memformat Timestamp dari Firebase
  String _formatJoinDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Tanggal bergabung tidak diketahui';
    }
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
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _uid != null ? _authService.getUserDataStream(_uid!) : null,
          builder: (context, snapshot) {
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Gagal memuat status akun'));
            }

            // Ekstrak data dari snapshot
            final userData = snapshot.data!.data();
            final String email = userData?['email'] ?? 'Email tidak ditemukan';
            final Timestamp? joinTimestamp = userData?['createdAt'];
            final String joinDate = _formatJoinDate(joinTimestamp);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountStatusInfo(
                  joinDate: 'Bergabung sejak: $joinDate',
                  linkedAccount: 'Email: $email',
                ),
                const SizedBox(height: 32),
                const DeleteAccountSection(), 
              ],
            );
          },
        ),
      ),
    );
  }
}