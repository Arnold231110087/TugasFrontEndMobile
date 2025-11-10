import 'package:flutter/material.dart';

class SearchAccount extends StatelessWidget {
  final String name;
  final String followers;
  final bool followsYou;
  final bool isFriend;
  final double? rating;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; // <-- 1. TAMBAHKAN PARAMETER INI

  const SearchAccount({
    super.key,
    required this.name,
    required this.followers,
    this.followsYou = false,
    this.isFriend = false,
    this.rating,
    this.onDelete,
    this.onTap, // <-- 2. TAMBAHKAN DI KONSTRUKTOR
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // 3. BUNGKUS 'Container' DENGAN 'InkWell'
    return InkWell(
      onTap: onTap, // <-- Gunakan parameter onTap di sini
      // Beri sedikit highlight saat diklik
      splashColor: theme.splashColor,
      highlightColor: theme.highlightColor,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/profile1.png'),
            ),
            const SizedBox(width: 16),
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
                  const SizedBox(height: 2),
                  Text(
                    followers,
                    style: theme.textTheme.labelSmall,
                  ),
                  if (isFriend || followsYou) const SizedBox(height: 8),
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
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    rating.toString(),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            const SizedBox(width: 20),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.cancel),
              )
          ],
        ),
      ),
    );
  }
}