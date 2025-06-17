import 'package:flutter/material.dart';
import '../utils/rupiah_format.dart';

class HistoryComponent extends StatelessWidget {
  final String title;
  final String description;

  final String profile;
  final int price;
  final String date;
  final String time;
  final bool success;

  const HistoryComponent({
    super.key,
    required this.title,
    required this.description,
    required this.profile,
    required this.date,
    required this.time,
    required this.price,
    required this.success,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          titleAlignment: ListTileTitleAlignment.center,
          leading: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              child: Icon(
                success ? Icons.check : Icons.close,
                size: 30,
                color: success ? Colors.green : Colors.red,
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('$description\n$date $time'),
          isThreeLine: true,
          onTap: (){},
          trailing: Text(rupiahFormat(price), style: theme.textTheme.bodyLarge),
        ),
        Divider(),
      ],
    );
  }
}
