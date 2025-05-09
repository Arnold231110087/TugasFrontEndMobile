import 'package:flutter/material.dart';

class BankOption extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String icon;
  final String name;
  final String description;

  const BankOption({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: isSelected ? theme.textTheme.headlineSmall!.color! : theme.dividerColor,
          ),
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
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
                      fontSize: theme.textTheme.bodyLarge!.fontSize,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? theme.textTheme.headlineSmall!.color : theme.textTheme.labelSmall!.color,
            ),
          ],
        ),
      ),
    );
  }
}