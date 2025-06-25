import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String? comment;
  final String imageAsset;
  final IconData? icon;

  const NotificationCard({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.comment,
    required this.imageAsset,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(imageAsset),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.textTheme.titleLarge!.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium!.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall!.color,
                            ),
                          ),
                          if (icon != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Icon(
                                icon,
                                size: 14,
                                color: theme.primaryColor,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (comment != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'Komentar: "$comment"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    color: theme.textTheme.bodySmall!.color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
