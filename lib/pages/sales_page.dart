import 'package:flutter/material.dart';
import '../components/sales_card_component.dart';

class SalesPage extends StatelessWidget {
  SalesPage({super.key});

  final List<Map<String, dynamic>> sales = [
    {
      'username': 'Rendy',
      'time': '3 jam lalu',
      'rating': 5.0,
      'message': 'Logonya bagus. Sesuai dengan ekspetasiku. Designer juga sangat profesional, ramah, dan bertanggung jawab. Very good!',
      'profileImage': 'assets/images/profile1.png',
      'like': 0,
      'comment': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 14,
                );
              }),
            ),
            SizedBox(width: 6),
            Text(
              '5',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        SizedBox(height: 24),
        ...sales.expand<Widget>((sale) => [
          SalesCard(
            username: sale['username'],
            time: sale['time'],
            rating: sale['rating'],
            message: sale['message'],
            profileImage: sale['profileImage'],
            like: sale['like'],
            comment: sale['comment'],
          ),
          const SizedBox(height: 24),
        ]).toList()..removeLast(),
      ],
    );
  }
}
