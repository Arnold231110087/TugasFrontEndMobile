import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // State untuk Riwayat Pencarian (data statis/lokal)
  final List<Map<String, dynamic>> _searchedAccounts = [
    {'name': 'Jessica Bui', 'followers': '193 pengikut', 'rating': 4.8},
    {'name': 'Richardo Lieberio', 'followers': '198 pengikut', 'isFriend': true, 'rating': 5.0},
  ];

  // State untuk pencarian Logo
  final LogoDevService _logoService = LogoDevService();
  List<Map<String, dynamic>> _logoResults = [];
  bool _isSearchingLogo = false;
  String _logoError = '';

  // State untuk AuthService dan UID pengguna
  final AuthService _authService = AuthService();
  String? _myUid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    
    // Ambil UID pengguna yang sedang login
    _myUid = _authService.currentUser?.uid;
  }

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
        // --- LOGIKA TAB AKUN ---
        if (query.isEmpty) {
          setState(() {
            _isSearchingAccount = false;
            _filteredAccounts.clear();
            _noAccountResults = false;
          });
        } else {
          _searchAccounts(query);
        }
      } else {
        // --- LOGIKA TAB LOGO ---
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
  // Di file lib/pages/search_page.dart

  /// Fungsi untuk mencari akun di Firebase
  Future<void> _searchAccounts(String query) async {
    setState(() {
      _isSearchingAccount = true; 
      _noAccountResults = false;
      _filteredAccounts.clear();
    });

    try {
      // --- PERUBAHAN DI SINI ---
      // Kita tidak lagi menggunakan 'isEqualTo'.
      // Kita mencari 'username' yang "lebih besar dari atau sama dengan" query
      // DAN "lebih kecil dari" query + karakter 'batas akhir' \uf8ff.
      
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + '\uf8ff') // Karakter 'batas akhir'
          .limit(10)
          .get();
      // --- AKHIR PERUBAHAN ---

      List<Map<String, dynamic>> results = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> userData = doc.data();
        userData['uid'] = doc.id; // Simpan UID untuk navigasi
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
    setState(() {
      _isSearchingLogo = true;
      _logoError = '';
      _logoResults.clear();
    });

    try {
      final results = await _logoService.searchBrandLogos(query);
      setState(() {
        _logoResults = results;
      });
    } catch (e) {
      setState(() {
        _logoError = 'Gagal memuat logo: $e';
      });
    } finally {
      setState(() {
        _isSearchingLogo = false;
      });
    }
  }

  /// Fungsi untuk menghapus riwayat pencarian
  void _deleteSearchedAccount(int index) {
    setState(() {
      final String deletedName = _searchedAccounts[index]['name'];
      _searchedAccounts.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun "$deletedName" dihapus dari riwayat pencarian.'),
          backgroundColor: Colors.grey.shade700,
        ),
      );
    });
  }

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
            
            // --- LOGIKA ONTAP PENTING ---
            onTap: () {
              if (uid == _myUid) {
                // INI PROFIL SAYA
                // Panggil method 'onItemTapped' dari parent (MainNavigation)
                context.findAncestorStateOfType<MainNavigationState>()?.onItemTapped(4); // 4 = index Akun
              } else {
                // INI PROFIL ORANG LAIN
                // Push halaman baru (tanpa bottom bar)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // AccountPage akan menampilkan profil orang lain
                    builder: (context) => AccountPage(userId: uid), 
                  ),
                );
              }
            },
            // --- AKHIR LOGIKA ONTAP ---
          );
        },
      );
    }

    // Jika tidak sedang mencari (query kosong), tampilkan riwayat
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
             Text('Lihat semua', style: theme.textTheme.headlineSmall),
           ],
        ),
        const SizedBox(height: 12),
        ...List.generate(_searchedAccounts.length, (index) {
          final account = _searchedAccounts[index];
          return SearchAccount(
            key: ValueKey(account['name']),
            name: account['name'],
            followers: account['followers'],
            followsYou: account['followsYou'] ?? false,
            isFriend: account['isFriend'] ?? false,
            rating: account['rating'],
            onDelete: () => _deleteSearchedAccount(index),
            onTap: () {
              // TODO: Anda juga bisa buat navigasi dari riwayat jika punya UID
            },
          );
        }),
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