import 'package:flutter/material.dart';
import 'package:logo_marketplace/components/best_designer_card_component.dart';
import 'package:logo_marketplace/components/followed_card_component.dart';
import 'package:logo_marketplace/components/transaction_card_component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'LOGODESAIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.displayLarge!.color,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Desainer dengan penjualan terbanyak pada Bulan Desember',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 104,
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
                  SizedBox(width: 12),
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
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaksi terkini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Lihat semua', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            SizedBox(height: 12),
            TransactionCard(
              name: 'Kevin Durant',
              message: 'telah menyelesaikan sebuah transaksi',
              rating: 5.0,
              imageAsset: 'images/profile3.png',
            ),
            SizedBox(height: 12),
            TransactionCard(
              name: 'Ahmad',
              message: 'telah menyelesaikan sebuah transaksi',
              rating: 4.0,
              imageAsset: 'images/profile4.png',
            ),
            SizedBox(height: 48),
            Text(
              'Akun yang anda ikuti',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            FollowedCard(
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
              like: '89',
              comment: '6',
            ),
          ],
        ),
      ),
    );
  }
}
