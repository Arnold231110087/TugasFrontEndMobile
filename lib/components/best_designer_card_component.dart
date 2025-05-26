import 'package:flutter/material.dart';

class BestDesignerCard extends StatelessWidget {
  final String name;
  final String sales;
  final double rating;
  final String followers;
  final String imageAsset;

  const BestDesignerCard({
    super.key,
    required this.name,
    required this.sales,
    required this.rating,
    required this.followers,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 260,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
      ),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 28),
              SizedBox(height: 12),
              Text(
                followers,
                style: theme.textTheme.labelSmall,
              ),
            ],
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
                  sales,
                  style: theme.textTheme.labelSmall,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: List.generate(rating.ceil(), (index) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber, // Warna bintang tetap sama (tidak menggunakan tema)
                          size: 14,
                        );
                      }),
                    ),
                    SizedBox(width: 6),
                    Text(
                      rating.toString(),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}