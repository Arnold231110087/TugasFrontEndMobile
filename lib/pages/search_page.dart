import 'package:flutter/material.dart';
import '../components/search_account_component.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredAccounts = [];
  bool _isSearching = false;
  bool _noResultsFound = false;

  final List<Map<String, dynamic>> searchedAccounts = [
    {'name': 'Jessica Bui', 'followers': '193 pengikut', 'rating': 4.8},
    {
      'name': 'Richardo Lieberio',
      'followers': '198 pengikut',
      'isFriend': true,
      'rating': 5.0,
    },
    {'name': 'Ahmad', 'followers': '3 pengikut', 'followsYou': true},
  ];

  final List<Map<String, dynamic>> randomAccounts = [
    {
      'name': 'Arnold Jefverson',
      'followers': '1 pengikut',
      'followsYou': true,
      'rating': 4,
    },
    {'name': 'Christy Hung', 'followers': 'Tidak ada pengikut'},
    {'name': 'Mamen Ganda', 'followers': '5 pengikut', 'rating': 4.5},
    {'name': 'Bambang', 'followers': 'Tidak ada pengikut', 'isFriend': true},
  ];

  List<Map<String, dynamic>> get _allAccounts => [
    ...searchedAccounts,
    ...randomAccounts,
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _filteredAccounts.clear();
        _noResultsFound = false;
      } else {
        _isSearching = true;
        _filteredAccounts =
            _allAccounts
                .where(
                  (account) => account['name'].toLowerCase().contains(query),
                )
                .toList();
        _noResultsFound = _filteredAccounts.isEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.center,
            style: theme.textTheme.bodyMedium,
            cursorColor: theme.textTheme.headlineSmall!.color,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: theme.textTheme.bodySmall!.color,
              ),
              hintText: 'Cari',
              hintStyle: theme.textTheme.labelMedium,
              border: InputBorder.none,
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: theme.textTheme.bodySmall!.color,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                      : null,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child:
            _isSearching
                ? _noResultsFound
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_off_outlined,
                            size: 64,
                            color: theme.textTheme.labelLarge!.color,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'User tidak ditemukan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.labelLarge!.color,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Coba cari dengan nama lain atau periksa ejaan.',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodySmall!.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      children:
                          _filteredAccounts.map((account) {
                            return SearchAccount(
                              name: account['name'],
                              followers: account['followers'],
                              followsYou: account['followsYou'] ?? false,
                              isFriend: account['isFriend'] ?? false,
                              rating: account['rating'],
                            );
                          }).toList(),
                    )
                : ListView(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                        Text(
                          'Lihat semua',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ...searchedAccounts.map((account) {
                      return SearchAccount(
                        name: account['name'],
                        followers: account['followers'],
                        followsYou: account['followsYou'] ?? false,
                        isFriend: account['isFriend'] ?? false,
                        rating: account['rating'],
                      );
                    }),
                    SizedBox(height: 36),
                    Text(
                      'Akun acak',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ...randomAccounts.map((account) {
                      return SearchAccount(
                        name: account['name'],
                        followers: account['followers'],
                        followsYou: account['followsYou'] ?? false,
                        isFriend: account['isFriend'] ?? false,
                        rating: account['rating'],
                      );
                    }),
                  ],
                ),
      ),
    );
  }
}
