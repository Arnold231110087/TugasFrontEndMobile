import 'package:flutter/material.dart';

class InputField1 extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;

  const InputField1({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextField(
      controller: controller,
      readOnly: this.readOnly,
      style: theme.textTheme.bodyMedium,
      cursorColor: theme.textTheme.headlineSmall!.color,
      decoration: InputDecoration(
        fillColor: theme.scaffoldBackgroundColor,
        labelText: label,
        labelStyle: theme.textTheme.labelMedium,
        focusColor: theme.textTheme.headlineSmall!.color,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: theme.textTheme.headlineSmall!.color!,
          ),
        ),
      ),
    );
  }
}