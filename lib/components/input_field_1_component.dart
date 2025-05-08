import 'package:flutter/material.dart';

class InputField1 extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const InputField1({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextField(
      controller: controller,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        fillColor: theme.scaffoldBackgroundColor,
        labelText: label,
        labelStyle: theme.textTheme.labelMedium,
        focusColor: theme.textTheme.headlineSmall!.color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.textTheme.headlineSmall!.color!),
        ),
      ),
    );
  }
}