import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage('images/profile1.png')),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Valerio Liuz Kienata", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("19 hours ago", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text("This is a test post to create an upload feature for photo/video."),
          SizedBox(height: 10),
          Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(child: Text("Preview")),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.favorite_border),
              Icon(Icons.comment),
              Icon(Icons.share),
            ],
          )
        ],
      ),
    );
  }
}
