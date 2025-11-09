import 'package:flutter/material.dart';

class DrawerSection extends StatelessWidget {
  final String section;
  final List<Map<String, dynamic>> tiles;

  const DrawerSection({super.key, required this.section, required this.tiles});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(section, style: theme.textTheme.labelSmall),
        ),
        ...tiles.map((tile) {
          return ListTile(
            title: Text(tile['title'], style: theme.textTheme.bodyMedium),
            leading: Icon(
              tile['icon'],
              color: theme.textTheme.bodyMedium!.color,
            ),
            onTap: () {
              Navigator.of(context).pop();
              if (tile['page'] != null) {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => tile['page']));
              }
            },
          );
        }),
      ],
    );
  }
}
