import 'package:flutter/material.dart';
import 'package:logo_marketplace/components/search_account_component.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final List<Map<String, dynamic>> searchedAccounts = [
    {'name': 'Jessica Bui', 'followers': '193 pengikut', 'rating': 4.8},
    {'name': 'Richardo Lieberio', 'followers': '198 pengikut', 'isFriend': true, 'rating': 5.0},
    {'name': 'Ahmad', 'followers': '3 pengikut', 'followsYou': true},
  ];

  final List<Map<String, dynamic>> randomAccounts = [
    {'name': 'Arnold Jefverson', 'followers': '1 pengikut', 'followsYou': true, 'rating': 4},
    {'name': 'Christy Hung', 'followers': 'Tidak ada pengikut'},
    {'name': 'Mamen Ganda', 'followers': '5 pengikut', 'rating': 4.5},
    {'name': 'Bambang', 'followers': 'Tidak ada pengikut', 'isFriend': true},
  ];

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
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.center,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: theme.textTheme.bodySmall!.color,
              ),
              hintText: 'Cari',
              hintStyle: theme.textTheme.labelMedium,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 16,
            ),
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
              ...randomAccounts.map((account) {
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
      ),
    );
  }
}
