import 'package:flutter/material.dart';
import '../utils/rupiah_format.dart';

class HistoryComponent extends StatelessWidget {
  final Map item;

  const HistoryComponent({
    super.key,
    required this.item,
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
                item['success'] ? Icons.check : Icons.close,
                size: 30,
                color: item['success'] ? Colors.green : Colors.red,
              ),
            ),
          ),
          title: Text(item['title']),
          subtitle: Text('${item['description']}\n${item['date']} ${item['time']}'),
          isThreeLine: true,
          onTap: (){},
          trailing: Text(rupiahFormat(item['price']), style: theme.textTheme.bodyLarge),
        ),
        Divider(),
      ],
    );
  }
}
