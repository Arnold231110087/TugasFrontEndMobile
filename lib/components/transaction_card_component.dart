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
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
        color: theme.cardColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageAsset),
            radius: 24,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' $message'),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(rating.ceil(), (index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14,
                    );
                  }),
                  SizedBox(width: 6),
                  Text(
                    rating.toString(),
                    style: theme.textTheme.labelSmall,
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