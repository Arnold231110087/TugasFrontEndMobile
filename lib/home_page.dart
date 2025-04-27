import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Color primaryColor = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Desainer terbaik",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Desainer dengan penjualan terbanyak pada Bulan Desember",
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 160, // ditambah agar lebih panjang
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDesignerCard(
                    name: "Richardo Lieberio",
                    sales: "17 Penjualan",
                    rating: 5.0,
                    followers: "198 Pengikut",
                    imageAsset: "images/profile1.png",
                  ),
                  _buildDesignerCard(
                    name: "Jessica Bui",
                    sales: "10 Penjualan",
                    rating: 4.8,
                    followers: "193 Pengikut",
                    imageAsset: "images/profile2.png",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transaksi terkini",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Lihat semua", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            _buildTransactionCard(
              name: "Kevin Durant",
              message: "telah menyelesaikan sebuah transaksi",
              rating: 5.0,
              sales: "12 Penjualan",
              imageAsset: "images/profile3.png",
            ),
            _buildTransactionCard(
              name: "Ahmad",
              message: "telah menyelesaikan sebuah transaksi",
              rating: 4.0,
              sales: "3 Penjualan",
              imageAsset: "images/profile4.png",
            ),
            SizedBox(height: 20),
            Text(
              "Akun yang anda ikuti",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildFollowedCard(
              username: "Rendy",
              time: "3 jam lalu",
              message:
                  "Beberapa logo yang pernah aku kerjakan untuk giant companies yang ada di Indonesia",
              logos: [
                "images/bca.png",
                "images/garuda.png",
                "images/gojek.png",
                "images/pertamina.png",
              ],
              profileImage: "images/profile5.png",
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDesignerCard({
    required String name,
    required String sales,
    required double rating,
    required String followers,
    required String imageAsset,
  }) {
    return Container(
      width: 260,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 28),
              SizedBox(height: 6),
              Text(
                followers,
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                SizedBox(height: 2),
                Text(sales, style: TextStyle(fontSize: 11)),
                SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.amber, size: 14);
                  }),
                ),
                Text(rating.toString(), style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard({
    required String name,
    required String message,
    required double rating,
    required String sales,
    required String imageAsset,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 25),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$name $message", style: TextStyle(fontSize: 13)),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.amber, size: 14);
                  }),
                ),
                Text(
                  sales,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowedCard({
    required String username,
    required String time,
    required String message,
    required List<String> logos,
    required String profileImage,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(profileImage)),
              SizedBox(width: 10),
              Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Icon(Icons.more_vert),
            ],
          ),
          SizedBox(height: 10),
          Text(message),
          if (logos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                spacing: 10,
                children:
                    logos.map((logo) => Image.asset(logo, width: 70)).toList(),
              ),
            ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 20),
              SizedBox(width: 4),
              Text("89"),
              SizedBox(width: 16),
              Icon(Icons.comment_outlined, size: 20),
              SizedBox(width: 4),
              Text("6"),
            ],
          ),
        ],
      ),
    );
  }
}
