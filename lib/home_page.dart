import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Color primaryColor = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "LOGODESAIN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        ],
      ),
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
                    context,
                    name: "Richardo Lieberio",
                    sales: "17 Penjualan",
                    rating: 5.0,
                    followers: "198 Pengikut",
                    imageAsset: "images/profile1.png",
                  ),
                  _buildDesignerCard(
                    context,
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
              context,
              name: "Kevin Durant",
              message: "telah menyelesaikan sebuah transaksi",
              rating: 5.0,
              sales: "12 Penjualan",
              imageAsset: "images/profile3.png",
            ),
            _buildTransactionCard(
              context,
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
              context,
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

  Widget _buildDesignerCard(
    BuildContext context, {
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
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ), // Divider mengikuti tema
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor, // Background mengikuti tema
      ),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 28),
              SizedBox(height: 6),
              Text(
                followers,
                style: TextStyle(
                  fontSize: 10,
                  color:
                      Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color, // Menggunakan warna teks sesuai tema
                ),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color:
                        Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color, // Menggunakan warna teks sesuai tema
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  sales,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color, // Warna teks sesuai tema
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color:
                          Colors
                              .amber, // Warna bintang tetap sama (tidak menggunakan tema)
                      size: 14,
                    );
                  }),
                ),
                Text(
                  rating.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color, // Warna teks sesuai tema
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowedCard(
    BuildContext context, {
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
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(profileImage)),
              SizedBox(width: 10),
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Spacer(),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
            ],
          ),
          SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          if (logos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 10,
                children:
                    logos.map((logo) => Image.asset(logo, width: 50)).toList(),
              ),
            ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              SizedBox(width: 4),
              Text(
                "89",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(width: 16),
              Icon(
                Icons.comment_outlined,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              SizedBox(width: 4),
              Text(
                "6",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildTransactionCard(
  BuildContext context, { // Menambahkan context sebagai parameter
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
      border: Border.all(
        color: Theme.of(context).dividerColor,
      ), // Divider sesuai tema
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor, // Background sesuai tema
    ),
    child: Row(
      children: [
        CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 25),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$name $message",
                style: TextStyle(
                  fontSize: 13,
                  color:
                      Theme.of(
                        context,
                      ).textTheme.bodyLarge?.color, // Warna teks sesuai tema
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber, // Warna bintang tetap sama
                    size: 14,
                  );
                }),
              ),
              Text(
                sales,
                style: TextStyle(
                  fontSize: 11,
                  color:
                      Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.grey[600], // Warna teks sesuai tema
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
