import 'package:flutter/material.dart';

class SearchLogoComponent extends StatelessWidget {
  final String name;
  final String domain;
  final String logoUrl;

  const SearchLogoComponent({
    super.key,
    required this.name,
    required this.domain,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 5,
          )
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            logoUrl,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 40),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyMedium!.color,
          ),
        ),
        subtitle: Text(domain),
      ),
    );
  }
}
