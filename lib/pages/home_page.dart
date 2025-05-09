import 'package:flutter/material.dart';
import '../components/best_designer_card_component.dart';
import '../components/post_card_component.dart';
import '../components/transaction_card_component.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                color: theme.textTheme.displaySmall!.color
              ),
              color: theme.textTheme.displaySmall!.color,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desainer terbaik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: theme.textTheme.bodyLarge!.fontSize,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Desainer dengan penjualan terbanyak pada Bulan Desember',
              style: theme.textTheme.bodySmall,
            ),
            SizedBox(height: 24),
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
                    imageAsset: 'images/profile1.png',
                  ),
                  SizedBox(width: 20),
                  BestDesignerCard(
                    name: 'Jessica Bui',
                    sales: '10 Penjualan',
                    rating: 4.8,
                    followers: '193 Pengikut',
                    imageAsset: 'images/profile2.png',
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
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
            SizedBox(height: 24),
            TransactionCard(
              name: 'Kevin Durant',
              message: 'telah menyelesaikan sebuah transaksi',
              rating: 5.0,
              imageAsset: 'images/profile3.png',
            ),
            SizedBox(height: 16),
            TransactionCard(
              name: 'Ahmad',
              message: 'telah menyelesaikan sebuah transaksi',
              rating: 4.0,
              imageAsset: 'images/profile4.png',
            ),
            SizedBox(height: 60),
            Text(
              'Akun yang anda ikuti',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: theme.textTheme.bodyLarge!.fontSize,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: 24),
            PostCard(
              username: 'Rendy',
              time: '3 jam lalu',
              message: 'Beberapa logo yang pernah aku kerjakan untuk giant companies yang ada di Indonesia',
              logos: [
                'images/bca.png',
                'images/garuda.png',
                'images/gojek.png',
                'images/pertamina.png',
              ],
              profileImage: 'images/profile5.png',
              like: 89,
              comment: 6,
            ),
          ],
        ),
      ),
    );
  }
}
