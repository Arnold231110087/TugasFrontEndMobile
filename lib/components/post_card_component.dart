import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String time;
  final String message;
  final List<String> logos;
  final String profileImage;
  final int like;
  final int comment;

  const PostCard({
    super.key,
    required this.username,
    required this.time,
    required this.message,
    required this.logos,
    required this.profileImage,
    required this.like,
    required this.comment,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage(profileImage)),
              SizedBox(width: 12),
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: theme.textTheme.bodyMedium!.fontSize,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
              Spacer(),
              Text(
                time,
                style: theme.textTheme.labelSmall,
              ),
              SizedBox(width: 16),
              Icon(
                Icons.more_vert,
                color: theme.textTheme.bodySmall!.color,
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(color: theme.textTheme.bodyLarge!.color),
          ),
          if (logos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Wrap(
                spacing: 12,
                children: logos.map((logo) => Image.asset(logo, width: 50)).toList(),
              ),
            ),
          SizedBox(height: 32),
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 20,
                color: theme.textTheme.bodySmall!.color,
              ),
              SizedBox(width: 4),
              Text(
                like.toString(),
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(width: 24),
              Icon(
                Icons.comment_outlined,
                size: 20,
                color: theme.textTheme.bodySmall!.color,
              ),
              SizedBox(width: 4),
              Text(
                comment.toString(),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}