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
    return Container(
      width: 260,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          Column(
            children: [
              CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 28),
              SizedBox(height: 8),
              Text(
                followers,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
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
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Text(
                  sales,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                SizedBox(height: 4),
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
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color:Theme.of(context).textTheme.bodyMedium!.color,
                      ),
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