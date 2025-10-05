import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // NEW
import 'chat_page.dart';
import 'post_follow_page.dart'; 
import '../components/best_designer_card_component.dart';
import '../components/post_card_component.dart';
import '../components/transaction_card_component.dart';
import 'designer_account_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                    'Halo, ${username.isNotEmpty ? username : email}',
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
                  'Desainer dengan penjualan terbanyak pada Bulan Desember',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 119,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      BestDesignerCard(
                        name: 'Richardo Lieberio',
                        sales: '17 Penjualan',
                        rating: 5.0,
                        followers: '198 Pengikut',
                        imageAsset: 'assets/images/profile1.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DesignerAccountPage(
                                designerName: 'Richardo Lieberio',
                                imageAsset: 'assets/images/profile1.png',
                                sales: '17 Penjualan',
                                rating: 5.0,
                                followers: '198 Pengikut',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      BestDesignerCard(
                        name: 'Jessica Bui',
                        sales: '10 Penjualan',
                        rating: 4.8,
                        followers: '193 Pengikut',
                        imageAsset: 'assets/images/profile2.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DesignerAccountPage(
                                designerName: 'Jessica Bui',
                                imageAsset: 'assets/images/profile2.png',
                                sales: '10 Penjualan',
                                rating: 4.8,
                                followers: '193 Pengikut',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
                      onPressed: () {},
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DesignerAccountPage(
                          designerName: 'Kevin Durant',
                          imageAsset: 'assets/images/profile3.png',
                          sales: '15 Penjualan',
                          rating: 5.0,
                          followers: '150 Pengikut',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TransactionCard(
                  name: 'Ahmad',
                  message: 'telah menyelesaikan sebuah transaksi',
                  rating: 4.0,
                  imageAsset: 'assets/images/profile4.png',
                  onProfileTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DesignerAccountPage(
                          designerName: 'Ahmad',
                          imageAsset: 'assets/images/profile4.png',
                          sales: '8 Penjualan',
                          rating: 4.0,
                          followers: '90 Pengikut',
                        ),
                      ),
                    );
                  },
                ),
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
