import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Color primaryColor = Color(0xFF1E3A8A); // warna biru

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("LOGODESAIN", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Desainer Terbaik
            Text("Desainer terbaik", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Desainer dengan penjualan terbaik pada Bulan Desember"),
            SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDesignerCard("Richardo Lieberio", "17 Penjualan", 5.0, "assets/profile1.png"),
                  _buildDesignerCard("Jessica Bui", "10 Penjualan", 4.8, "assets/profile2.png"),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Transaksi Terkini
            _buildSectionHeader("Transaksi terkini", onViewAll: () {}),
            _buildTransactionCard("Kevin Durant telah menyelesaikan sebuah transaksi", 5.0, "assets/profile3.png"),
            _buildTransactionCard("Ahmad telah menyelesaikan sebuah transaksi", 4.0, "assets/profile4.png"),
            SizedBox(height: 20),

            // Akun yang anda ikuti
            Text("Akun yang anda ikuti", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildFollowedCard(
              username: "Rendy",
              time: "3 jam lalu",
              message: "Beberapa logo yang pernah dikerjakan untuk giant companies yang ada di Indonesia",
              logos: [
                "assets/bca.png",
                "assets/aruda.png",
                "assets/gojek.png",
                "assets/pertamina.png"
              ],
              profileImage: "assets/profile5.png",
            ),
            _buildFollowedCard(
              username: "Jessica Bui",
              time: "9 jam lalu",
              message: "Ui/UX yang bisa desain logo yang cool dan elegant",
              logos: [],
              profileImage: "assets/profile2.png",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  Widget _buildDesignerCard(String name, String sales, double rating, String imageAsset) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 25),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(sales, style: TextStyle(fontSize: 12)),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.amber, size: 16);
                  }),
                ),
                Text(rating.toString(), style: TextStyle(fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionCard(String message, double rating, String imageAsset) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 25),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, color: Colors.amber, size: 16);
                  }),
                ),
              ],
            ),
          )
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
              Text(username),
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
              child: Wrap(
                spacing: 10,
                children: logos.map((logo) => Image.asset(logo, width: 50)).toList(),
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
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text("Lihat semua"),
          ),
      ],
    );
  }
}
