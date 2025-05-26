import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String icon;
  final String url;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.isSelected,
    required this.name,
    required this.icon,
    required this.url,
    required this.onTap,
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
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Image.asset(icon, width: 40),
              const SizedBox(width: 12),
              Text(
                name,
                style: theme.textTheme.bodyMedium,
              ),
              Spacer(),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? theme.textTheme.headlineSmall!.color : theme.textTheme.labelSmall!.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}