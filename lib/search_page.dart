import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF1E3A8A);

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Cari",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Akun yang pernah dicari", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Lihat semua", style: TextStyle(fontSize: 12, color: Colors.blue)),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildAccountTile("Jessica Bui", "2 Pengikut", "Tidak mengikuti"),
                  _buildAccountTile("Richardo Lieberio", "198 Pengikut", "Teman"),
                  _buildAccountTile("Ahmad", "3 Pengikut", "Tidak mengikuti"),
                  SizedBox(height: 12),
                  Text("Akun acak", style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildAccountTile("Arnold Jefterson", "1 Pengikut", "Mengikuti anda", rating: 4.8),
                  _buildAccountTile("Christy Hung", "0 Pengikut", "Tidak ada rating"),
                  _buildAccountTile("Mamen Ganda", "5 Pengikut", "Teman", rating: 5.0),
                  _buildAccountTile("Bambang", "Tidak ada", "Tidak ada rating", rating: 3.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile(String name, String followers, String subtitle, {double? rating}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundImage: AssetImage("images/profile1.png")),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(followers, style: TextStyle(fontSize: 12)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          if (rating != null)
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 2),
                Text(rating.toString(), style: TextStyle(fontSize: 12)),
              ],
            )
        ],
      ),
    );
  }
}
