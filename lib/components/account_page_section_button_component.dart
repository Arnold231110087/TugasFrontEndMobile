import 'package:flutter/material.dart';

class AccountPageSectionButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const AccountPageSectionButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive ? theme.textTheme.headlineSmall!.color : theme.textTheme.labelSmall!.color,
        ),
        onPressed: onPressed
      ),
    );
  }
}