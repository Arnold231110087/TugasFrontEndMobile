import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_arnold/services/firebase.dart'; 
import 'account_page.dart';

class LogoDetailPage extends StatefulWidget {
  final String name;
  final String domain;
  final String logoUrl;

  const LogoDetailPage({
    super.key,
    required this.name,
    required this.domain,
    required this.logoUrl,  
  });

  @override
  State<LogoDetailPage> createState() => _LogoDetailPageState();
}

class _LogoDetailPageState extends State<LogoDetailPage> {
  final AuthService _authService = AuthService();
  String? _randomDesignerUid;
  bool _isLoadingDesigner = true;

  @override
  void initState() {
    super.initState();
    _loadRandomDesigner();
  }

  /// Mengambil 1 user acak dari Firestore, KECUALI diri sendiri
  Future<void> _loadRandomDesigner() async {
    setState(() => _isLoadingDesigner = true);
    
    try {
      final currentUid = _authService.currentUser?.uid;

      // 1. Query ke Firebase
      // "Ambil semua user yang ID-nya TIDAK SAMA DENGAN ID saya"
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUid) 
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 2. Pilih satu secara acak dari hasil yang didapat
        final randomIndex = Random().nextInt(querySnapshot.docs.length);
        final randomDoc = querySnapshot.docs[randomIndex];
        
        // 3. Simpan UID desainer tersebut
        _randomDesignerUid = randomDoc.id;
      } else {
        print("Tidak ada desainer lain ditemukan.");
      }
    } catch (e) {
      print("Gagal memuat desainer acak: $e");
    }
    
    if(mounted) {
      setState(() => _isLoadingDesigner = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: theme.textTheme.displayLarge?.copyWith(
            color: theme.appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor, 
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.logoUrl,
                height: 120,
                width: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.name,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.domain,
              style: theme.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // TOMBOL PESAN LOGO
            ElevatedButton.icon(
              // Tombol nonaktif jika loading atau tidak ada desainer lain
              onPressed: _isLoadingDesigner || _randomDesignerUid == null
                  ? null 
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AccountPage(
                            // Kirim UID desainer acak (yang bukan Anda)
                            userId: _randomDesignerUid!, 
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              label: Text(
                _isLoadingDesigner ? "Memuat Desainer..." : "Pesan Logo",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.appBarTheme.backgroundColor ?? const Color(0xFF1E40AF),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}