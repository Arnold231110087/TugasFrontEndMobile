import 'package:flutter/material.dart';

class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage('images/avatar.png')),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rendy", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("3 hours ago", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text("5.0"),
              SizedBox(width: 10),
              Text("1 Sale"),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "The logo is okay. Matches my expectations. Very responsive and cheap price. Nice job!",
          ),
        ],
      ),
    );
  }
}
