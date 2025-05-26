import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String? comment;
  final String imageAsset;

  const NotificationCard({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.comment,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: comment != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          CircleAvatar(backgroundImage: AssetImage(imageAsset)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
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
                    ),
                    SizedBox(width: 16),
                    Text(
                      time,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
                if (comment != null) ...[
                  SizedBox(height: 8),
                  Text(
                    comment!,
                    style: theme.textTheme.labelMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}