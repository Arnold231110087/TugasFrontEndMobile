import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_arnold/services/database.dart';
import 'package:mobile_arnold/services/firebase.dart'; 
import '../components/search_account_component.dart'; // Komponen UI
import 'logo_detail_page.dart'; // Halaman detail logo Anda
import '../services/logo_dev_service.dart'; // Service logo Anda
import 'account_page.dart'; // Halaman Akun untuk navigasi
import '../main.dart'; // <-- Import main.dart

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  Timer? _debounce;

  // State untuk hasil pencarian Akun dari Firebase
  List<Map<String, dynamic>> _filteredAccounts = [];
  bool _isSearchingAccount = false;
  bool _noAccountResults = false;

  // --- 2. PERBARUI STATE RIWAYAT ---
  List<Map<String, dynamic>> _searchedAccounts = []; // Sekarang dinamis
  bool _isLoadingHistory = true; // State loading untuk riwayat
  // --- AKHIR PERUBAHAN ---

  // State untuk pencarian Logo
  final LogoDevService _logoService = LogoDevService();
  List<Map<String, dynamic>> _logoResults = [];
  bool _isSearchingLogo = false;
  String _logoError = '';

  // State untuk AuthService dan UID pengguna
  final AuthService _authService = AuthService();
  final LocalDatabase _localDb = LocalDatabase(); // <-- 3. TAMBAHKAN INSTANCE SQFLITE
  String? _myUid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    
    _myUid = _authService.currentUser?.uid;
    // --- 4. MUAT RIWAYAT DARI LOKAL SAAT INIT ---
    _loadLocalHistory();
    // --- AKHIR TAMBAHAN ---
  }

  // --- 5. FUNGSI BARU UNTUK MEMUAT RIWAYAT ---
// Di file lib/pages/search_page.dart

  Future<void> _loadLocalHistory() async {
    if (_myUid == null) return;
    setState(() => _isLoadingHistory = true);
    final history = await _localDb.getSearchHistory(_myUid!);
    if (mounted) {
      setState(() {
        // --- PERBAIKAN DI SINI ---
        // Buat salinan list yang 'growable' (bisa diubah)
        _searchedAccounts = List.from(history);
        // --- AKHIR PERBAIKAN ---
        _isLoadingHistory = false;
      });
    }
  }
  // --- AKHIR FUNGSI BARU ---

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  /// Dipanggil setiap kali teks di search bar berubah
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase(); 

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (_tabController.index == 0) {
        // --- LOGIKA TAB AKUN (DIPERBARUI) ---
        if (query.isEmpty) {
          setState(() {
            _isSearchingAccount = false;
            _filteredAccounts.clear();
            _noAccountResults = false;
          });
          _loadLocalHistory(); // <-- Muat ulang riwayat
        } else {
          _searchAccounts(query);
        }
      } else {
        // --- LOGIKA TAB LOGO (TETAP SAMA) ---
        if (query.isNotEmpty) {
          _searchLogos(query);
        } else {
          setState(() {
            _logoResults.clear();
            _logoError = '';
          });
        }
      }
    });
  }

  /// Fungsi untuk mencari akun di Firebase
  Future<void> _searchAccounts(String query) async {
    // ... (Fungsi ini tetap sama, tidak ada perubahan)
    setState(() {
      _isSearchingAccount = true; 
      _noAccountResults = false;
      _filteredAccounts.clear();
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + '\uf8ff') 
          .limit(10)
          .get();

      List<Map<String, dynamic>> results = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userData = doc.data();
        userData['uid'] = doc.id; 
        results.add(userData);
      }

      setState(() {
        _filteredAccounts = results;
        _noAccountResults = results.isEmpty;
      });
    } catch (e) {
      print("Error saat mencari akun: $e");
      setState(() {
        _noAccountResults = true; 
      });
    }
  }

  /// Fungsi untuk mencari logo (dari service Anda)
  Future<void> _searchLogos(String query) async {
    // ... (Fungsi ini tetap sama, tidak ada perubahan)
  }

  // --- 6. PERBARUI FUNGSI HAPUS RIWAYAT ---
  void _deleteSearchedAccount(Map<String, dynamic> account) async {
    if (_myUid == null) return;
    // Ambil 'searchedUid' dari data SQFlite
    final String searchedUid = account['searchedUid']; 
    final String username = account['username'];

    // Hapus dari state
    setState(() {
      _searchedAccounts.removeWhere((item) => item['searchedUid'] == searchedUid);
    });
    
    // Hapus dari SQFlite (cepat)
    await _localDb.deleteSearchHistory(_myUid!, searchedUid);
    // Hapus dari Firebase (latar belakang)
    _authService.deleteSearchHistoryFromFirebase(_myUid!, searchedUid);


  }
  // --- AKHIR PERUBAHAN ---

  // --- 7. FUNGSI BARU UNTUK MENYIMPAN RIWAYAT ---
  Future<void> _saveToHistory(Map<String, dynamic> account) async {
     if (_myUid == null || _myUid == account['uid']) return; // Jangan simpan diri sendiri

     final historyItem = {
       'userId': _myUid!,
       'searchedUid': account['uid'], // uid dari user yg dicari
       'username': account['username'],
       'timestamp': DateTime.now().millisecondsSinceEpoch
     };

     // Simpan ke SQFlite (cepat)
     await _localDb.addSearchHistory(historyItem);
     // Simpan ke Firebase (latar belakang)
     _authService.saveSearchHistoryToFirebase(_myUid!, account);
  }
  // --- AKHIR FUNGSI BARU ---


  /// Membangun UI untuk tab "Akun"
  Widget _buildAccountTab(ThemeData theme) {
    // Jika sedang mencari (query tidak kosong)
    if (_isSearchingAccount) {
      if (_noAccountResults) {
        return _buildNoAccountFound(theme);
      }
      // Tampilkan hasil dari Firebase
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: _filteredAccounts.length,
        itemBuilder: (context, index) {
          final account = _filteredAccounts[index];
          
          final String username = account['username'] ?? 'Nama tidak ada';
          final String uid = account['uid'];
          final String followers = (account['followerCount']?.toString() ?? '0') + ' pengikut';
          final double? rating = (account['rating'] is num) ? (account['rating'] as num).toDouble() : null;

          return SearchAccount(
            key: ValueKey(uid), 
            name: username,
            followers: followers,
            rating: rating,
            followsYou: false, 
            isFriend: false,   
            onDelete: null, 
            onTap: () {
              // --- 8. SIMPAN RIWAYAT SAAT DIKLIK ---
              _saveToHistory(account); 
              // --- AKHIR PERUBAHAN ---
              
              if (uid == _myUid) {
                context.findAncestorStateOfType<MainNavigationState>()?.onItemTapped(4); 
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(userId: uid), 
                  ),
                );
              }
            },
          );
        },
      );
    }

    // --- (UI RIWAYAT PENCARIAN DIPERBARUI) ---
    // Jika tidak sedang mencari (query kosong), tampilkan riwayat
    if (_isLoadingHistory) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
               'Akun yang pernah dicari',
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: theme.textTheme.bodyMedium!.fontSize,
                 color: theme.textTheme.bodyMedium!.color,
               ),
             ),
            //  Text('Lihat semua', style: theme.textTheme.headlineSmall),
           ],
        ),
        const SizedBox(height: 12),
        if (_searchedAccounts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Center(
              child: Text(
                'Riwayat pencarian Anda kosong.',
                style: theme.textTheme.labelMedium,
              )
            ),
          )
        else
          ..._searchedAccounts.map((account) {
            // Data dari SQFlite
            final String username = account['username'];
            // 'searchedUid' dari SQFlite
            final String searchedUid = account['searchedUid']; 
            
            return SearchAccount(
              key: ValueKey(searchedUid),
              name: username,
              followers: 'Riwayat pencarian', // Subtitle
              onDelete: () => _deleteSearchedAccount(account),
              onTap: () {
                if (searchedUid == _myUid) {
                  context.findAncestorStateOfType<MainNavigationState>()?.onItemTapped(4); 
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPage(userId: searchedUid), 
                    ),
                  );
                }
              },
            );
          }).toList(),
      ],
    );
  }

  /// Membangun UI untuk 'user tidak ditemukan'
  Widget _buildNoAccountFound(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_outlined,
              size: 64, color: theme.textTheme.labelLarge!.color),
          const SizedBox(height: 16),
          Text('User tidak ditemukan',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.labelLarge!.color)),
          const SizedBox(height: 8),
          Text(
            'Coba cari dengan nama lain atau periksa ejaan.',
            style:
                TextStyle(fontSize: 14, color: theme.textTheme.bodySmall!.color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Membangun UI untuk tab "Logo"
  Widget _buildLogoTab(ThemeData theme) {
    return Column(
      children: [
        if (_isSearchingLogo)
          const Padding(
              padding: EdgeInsets.all(20), child: CircularProgressIndicator())
        else if (_logoError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(_logoError, style: TextStyle(color: Colors.red)),
          )
        else if (_searchController.text.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Masukkan nama brand untuk mencari logo'),
          )
        else if (_logoResults.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Logo tidak ditemukan'),
          )
        else
         Expanded(
          child: ListView.builder(
            itemCount: _logoResults.length,
            itemBuilder: (context, index) {
              final logo = _logoResults[index];
              return ListTile(
                leading: Image.network(
                  logo['logoUrl'],
                  height: 48,
                  width: 48,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
                title: Text(logo['name'] ?? 'Tidak Diketahui'),
                subtitle: Text(logo['domain'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogoDetailPage(
                        name: logo['name'] ?? 'Tidak diketahui',
                        domain: logo['domain'] ?? '',
                        logoUrl: logo['logoUrl'] ?? '',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build utama
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              final hint =
                  _tabController.index == 0 ? 'Cari akun...' : 'Cari logo...';
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: TextField(
                  key: ValueKey(hint),
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        color: theme.textTheme.bodySmall!.color),
                    hintText: hint,
                    border: InputBorder.none,
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                color: theme.textTheme.bodySmall!.color),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
          bottom: TabBar(
          controller: _tabController,
          labelColor: theme.appBarTheme.foregroundColor,
          unselectedLabelColor: theme.textTheme.labelSmall?.color,
          indicatorColor: theme.appBarTheme.foregroundColor,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: "Akun"),
            Tab(icon: Icon(Icons.image), text: "Logo"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAccountTab(theme),
          _buildLogoTab(theme),
        ],
      ),
    );
  }
}