import 'package:flutter/material.dart';

class SearchAccount extends StatelessWidget {
  final String name;
  final String followers;
  final bool followsYou;
  final bool isFriend;
  final double? rating;

  const SearchAccount({
    super.key,
    required this.name,
    required this.followers,
    this.followsYou = false,
    this.isFriend = false,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('images/profile1.png'),
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
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Text(
                  followers,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: 4),
                if (isFriend)
                  Text(
                    'Teman',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                if (followsYou)
                  Text(
                    'Mengikuti anda',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          if (rating != null)
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 2),
                Text(
                  rating.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}