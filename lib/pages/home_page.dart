import 'package:flutter/material.dart';
import 'package:mobile_arnold/services/firebase.dart';
import 'package:mobile_arnold/utils/string_format.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- 1. Tambahkan Import
import 'chat_page.dart';
import 'post_follow_page.dart'; 
import '../components/best_designer_card_component.dart';
import '../components/post_card_component.dart';
import '../components/transaction_card_component.dart';
import 'account_page.dart'; 
import '../providers/theme_provider.dart';

// --- 4. UBAH MENJADI STATEFULWIDGET ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  // --- 5. TAMBAHKAN STATE UNTUK DATA DINAMIS ---
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _bestDesigners = [];
  bool _isLoadingDesigners = true;
  // --- AKHIR TAMBAHAN ---

  @override
  void initState() {
    super.initState();
    _loadBestDesigners(); // Panggil fungsi load data
  }

  /// (BARU) Mengambil user dari Firestore
  Future<void> _loadBestDesigners() async {
    setState(() => _isLoadingDesigners = true);
    
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          // Ambil user selain diri sendiri
          .where(FieldPath.documentId, isNotEqualTo: _authService.currentUser?.uid) 
          .limit(5) // Ambil 5 user (ini acak sederhana)
          .get();

      List<Map<String, dynamic>> designers = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userData = doc.data();
        userData['uid'] = doc.id; // Simpan UID
        designers.add(userData);
      }

      if (mounted) {
        setState(() {
          _bestDesigners = designers;
          _isLoadingDesigners = false;
        });
      }
    } catch (e) {
      print("Gagal memuat desainer: $e");
      if (mounted) {
        setState(() {
          _isLoadingDesigners = false;
        });
      }
    }
  }

  Future<Map<String, String>> _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    final email = prefs.getString('email') ?? '';
    return {
      'username': username,
      'email': email,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // (Provider tema tidak lagi diperlukan di sini karena kita ambil dari context)
    // final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'LOGODESAIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: theme.textTheme.displaySmall!.color,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;
          final username = user['username'] ?? '';
          final email = user['email'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (username.isNotEmpty || email.isNotEmpty) ...[
                  Text(
                    'Halo, ${username.isNotEmpty ? username.toTitleCase() : email}',
                    style: TextStyle(
                      fontSize: theme.textTheme.bodyLarge!.fontSize,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Text(
                  'Desainer terbaik',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: theme.textTheme.bodyLarge!.fontSize,
                    color: theme.textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Lihat desainer populer di platform kami', // Ganti subjudul
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                
                // --- 6. PERBARUI BAGIAN INI ---
                SizedBox(
                  height: 119,
                  child: _isLoadingDesigners
                      ? const Center(child: CircularProgressIndicator())
                      : _bestDesigners.isEmpty
                          ? const Center(child: Text('Tidak ada desainer lain ditemukan.'))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _bestDesigners.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                final designer = _bestDesigners[index];
                                
                                // Ambil data dinamis
                                final String designerUid = designer['uid'];
                                final String designerName = (designer['username'] ?? 'Desainer').toString().toTitleCase();
                                final String sales = (designer['salesCount'] ?? 0).toString() + ' Penjualan';
                                final String followers = (designer['followerCount'] ?? 0).toString() + ' Pengikut';
                                final double rating = (designer['rating'] is num) ? (designer['rating'] as num).toDouble() : 0.0;
                                final String imageAsset = designer['profileImageUrl'] ?? 'assets/images/profile1.png';

                                return BestDesignerCard(
                                  name: designerName,
                                  sales: sales,
                                  rating: rating,
                                  followers: followers,
                                  imageAsset: imageAsset,
                                  onTap: () {
                                    // Navigasi ke AccountPage dengan UID
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AccountPage(
                                          userId: designerUid,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                ),
                // --- AKHIR PERUBAHAN ---

                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaksi terkini',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: theme.textTheme.bodyLarge!.fontSize,
                        color: theme.textTheme.bodyLarge!.color,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                         // TODO: Navigasi ke halaman 'HistoryPage'
                      },
                      child: Text(
                        'Lihat semua',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TransactionCard(
                  name: 'Kevin Durant',
                  message: 'telah menyelesaikan sebuah transaksi',
                  rating: 5.0,
                  imageAsset: 'assets/images/profile3.png',
                  onProfileTap: () {
                    // TODO: Ganti ini agar navigasi pakai UID jika datanya dinamis
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(userId: '...')));
                  },
                ),
                const SizedBox(height: 16),
                TransactionCard(
                  name: 'Ahmad',
                  message: 'telah menyelesaikan sebuah transaksi',
                  rating: 4.0,
                  imageAsset: 'assets/images/profile4.png',
                  onProfileTap: () {
                     // TODO: Ganti ini agar navigasi pakai UID jika datanya dinamis
                  },
                ),
                
                // --- BAGIAN INI TIDAK DISENTUH ---
                const SizedBox(height: 60),
                Text(
                  'Akun yang anda ikuti',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: theme.textTheme.bodyLarge!.fontSize,
                    color: theme.textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(height: 24),
                PostCard(
                  username: 'Rendy',
                  time: '3 jam lalu',
                  message:
                      'Beberapa logo yang pernah aku kerjakan untuk giant companies yang ada di Indonesia',
                  logos: [
                    'assets/images/bca.png',
                    'assets/images/garuda.png',
                    'assets/images/gojek.png',
                    'assets/images/pertamina.png',
                  ],
                  profileImage: 'assets/images/profile5.png',
                  like: 89,
                  comment: 6,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostDetailPage(
                          username: 'Rendy',
                          time: '3 jam lalu',
                          message:
                              'Beberapa logo yang pernah aku kerjakan untuk giant companies yang ada di Indonesia',
                          logos: [
                            'assets/images/bca.png',
                            'assets/images/garuda.png',
                            'assets/images/gojek.png',
                            'assets/images/pertamina.png',
                          ],
                          profileImage: 'assets/images/profile5.png',
                          like: 89,
                          comment: 6,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}