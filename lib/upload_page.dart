import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  UploadPage({super.key});
  final Color primaryColor = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,

        title: Text(
          "Unggahan Baru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("images/profile1.png"),
                ),
                SizedBox(width: 30),
                Text(
                  "Valerio Liuz Kienata",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextField(
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Tulis Sesuatu...",
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Upload")),
          ],
        ),
      ),
    );
  }
}
