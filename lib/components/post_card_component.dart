import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String time;
  final String message;
  final List<String> logos;
  final String profileImage;
  final int like;
  final int comment;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.username,
    required this.time,
    required this.message,
    required this.logos,
    required this.profileImage,
    required this.like,
    required this.comment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Info
              Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(profileImage)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username, style: theme.textTheme.bodyMedium),
                      Text(time, style: theme.textTheme.labelSmall),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(message, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: logos
                    .map((logo) => Image.asset(logo, height: 40))
                    .toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.favorite_border, size: 18, color: theme.iconTheme.color),
                  const SizedBox(width: 4),
                  Text('$like', style: theme.textTheme.labelSmall),
                  const SizedBox(width: 16),
                  Icon(Icons.comment_outlined, size: 18, color: theme.iconTheme.color),
                  const SizedBox(width: 4),
                  Text('$comment', style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
