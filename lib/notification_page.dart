import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "LOGODESAIN",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            name: "Arnold Jefverson",
            message: "memberikan komentar terhadap penjualan anda",
            time: "1 jam lalu",
            comment: "Buset. Congrats yah atas penjualan logo pertamamu",
            imageAsset: "assets/profile1.png",
          ),
          _buildNotificationCard(
            name: "Arnold Jefverson",
            message: "menyukai unggahan anda",
            time: "2 jam lalu",
            comment: "Hello World!!! Ini adalah postingan pertamaku...",
            imageAsset: "assets/profile1.png",
          ),
          _buildNotificationCard(
            name: "Richardo Lieberio",
            message: "menyukai unggahan anda",
            time: "8 jam lalu",
            comment: "Ini adalah postingan keduaku...",
            imageAsset: "assets/profile2.png",
          ),
          _buildNotificationCard(
            name: "Arnold Jefverson",
            message: "menyukai unggahan anda",
            time: "11 jam lalu",
            comment: "Ini adalah postingan keduaku...",
            imageAsset: "assets/profile1.png",
          ),
          _buildNotificationCard(
            name: "Richardo Lieberio",
            message: "Kini adalah teman anda",
            time: "13 jam lalu",
            imageAsset: "assets/profile2.png",
          ),
          _buildNotificationCard(
            name: "Richardo Lieberio",
            message: "mulai mengikuti anda",
            time: "15 jam lalu",
            imageAsset: "assets/profile2.png",
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String name,
    required String message,
    required String time,
    String? comment,
    required String imageAsset,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(imageAsset)),
              SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " $message"),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          if (comment != null) ...[
            SizedBox(height: 8),
            Text(
              comment,
              style: TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
