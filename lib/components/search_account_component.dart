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
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('images/profile1.png'),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: theme.textTheme.bodyMedium!.fontSize,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  followers,
                  style: theme.textTheme.labelSmall,
                ),
                if (isFriend || followsYou)
                  SizedBox(height: 8),
                if (isFriend)
                  Text(
                    'Teman',
                    style: theme.textTheme.labelSmall,
                  ),
                if (followsYou)
                  Text(
                    'Mengikuti anda',
                    style: theme.textTheme.labelSmall,
                  ),
              ],
            ),
          ),
          if (rating != null)
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                SizedBox(width: 2),
                Text(
                  rating.toString(),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
        ],
      ),
    );
  }
}