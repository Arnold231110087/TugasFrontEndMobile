import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String name;
  final String message;
  final double rating;
  final String imageAsset;

  const TransactionCard({
    super.key,
    required this.name,
    required this.message,
    required this.rating,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageAsset),
            radius: 24,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' $message'),
                  ],
                ),
              ),
              SizedBox(height: 2),
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
        ],
      ),
    );
  }
}