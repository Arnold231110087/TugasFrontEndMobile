import 'package:flutter/material.dart';
import 'dart:async';
import '../components/search_account_component.dart';
import '../components/search_logo_component.dart';
import 'logo_detail_page.dart';
import '../services/logo_dev_service.dart';

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

  List<Map<String, dynamic>> _filteredAccounts = [];
  bool _isSearchingAccount = false;
  bool _noAccountResults = false;

  final List<Map<String, dynamic>> _searchedAccounts = [
    {'name': 'Jessica Bui', 'followers': '193 pengikut', 'rating': 4.8},
    {'name': 'Richardo Lieberio', 'followers': '198 pengikut', 'isFriend': true, 'rating': 5.0},
    {'name': 'Ahmad', 'followers': '3 pengikut', 'followsYou': true},
  ];

  final List<Map<String, dynamic>> randomAccounts = [
    {'name': 'Arnold Jefverson', 'followers': '1 pengikut', 'followsYou': true, 'rating': 4.0},
    {'name': 'Christy Hung', 'followers': 'Tidak ada pengikut'},
    {'name': 'Mamen Ganda', 'followers': '5 pengikut', 'rating': 4.5},
    {'name': 'Bambang', 'followers': 'Tidak ada pengikut', 'isFriend': true},
  ];

  List<Map<String, dynamic>> get _allAccounts => [
        ..._searchedAccounts,
        ...randomAccounts,
      ];

  final LogoDevService _logoService = LogoDevService();
  List<Map<String, dynamic>> _logoResults = [];
  bool _isSearchingLogo = false;
  String _logoError = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (_tabController.index == 0) {
        setState(() {
          if (query.isEmpty) {
            _isSearchingAccount = false;
            _filteredAccounts.clear();
            _noAccountResults = false;
          } else {
            _isSearchingAccount = true;
            _filteredAccounts = _allAccounts
                .where((account) =>
                    account['name'].toLowerCase().contains(query))
                .toList();
            _noAccountResults = _filteredAccounts.isEmpty;
          }
        });
      } else {
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

  Widget _buildAccountTab(ThemeData theme) {
    return _isSearchingAccount
        ? _noAccountResults
            ? _buildNoAccountFound(theme)
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                itemCount: _filteredAccounts.length,
                itemBuilder: (context, index) {
                  final account = _filteredAccounts[index];
                  return SearchAccount(
                    key: ValueKey(account['name']),
                    name: account['name'],
                    followers: account['followers'],
                    followsYou: account['followsYou'] ?? false,
                    isFriend: account['isFriend'] ?? false,
                    rating: account['rating'],
                  );
                },
              )
        : ListView(
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
                );
              }),
              const SizedBox(height: 36),
              const Text('Akun acak',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...randomAccounts.map((account) {
                return SearchAccount(
                  key: ValueKey(account['name']),
                  name: account['name'],
                  followers: account['followers'],
                  followsYou: account['followsYou'] ?? false,
                  isFriend: account['isFriend'] ?? false,
                  rating: account['rating'],
                );
              }),
            ],
          );
  }

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
                              setState(() {
                                _filteredAccounts.clear();
                                _logoResults.clear();
                              });
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
