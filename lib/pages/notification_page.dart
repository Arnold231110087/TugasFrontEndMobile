import 'package:flutter/material.dart';
import '../components/notification_card_component.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      'name': 'Arnold Jefverson',
      'message': 'memberikan komentar terhadap penjualan anda',
      'time': '1 jam lalu',
      'comment': 'Buset. Congrats yah atas penjualan logo pertamamu',
      'imageAsset': 'images/profile1.png',
    },
    {
      'name': 'Arnold Jefverson',
      'message': 'menyukai unggahan anda',
      'time': '2 jam lalu',
      'comment': 'Hello World!!! Ini adalah postingan pertamaku...',
      'imageAsset': 'images/profile1.png',
    },
    {
      'name': 'Richardo Lieberio',
      'message': 'menyukai unggahan anda',
      'time': '8 jam lalu',
      'comment': 'Ini adalah postingan keduaku...',
      'imageAsset': 'images/profile2.png',
    },
    {
      'name': 'Arnold Jefverson',
      'message': 'menyukai unggahan anda',
      'time': '12 jam lalu',
      'comment': 'Ini adalah postingan keduaku...',
      'imageAsset': 'images/profile1.png',
    },
    {
      'name': 'Richardo Lieberio',
      'message': 'kini adalah teman anda',
      'time': '13 jam lalu',
      'imageAsset': 'images/profile2.png',
    },
    {
      'name': 'Richardo Lieberio',
      'message': 'mulai mengikuti anda',
      'time': '15 jam lalu',
      'imageAsset': 'images/profile2.png',
    },
  ];

  IconData? _getNotificationIcon(String message) {
    if (message.contains('menyukai unggahan anda')) {
      return Icons.favorite; 
    } else if (message.contains('memberikan komentar')) {
      return Icons.comment; 
    } else if (message.contains('mengikuti anda') || message.contains('kini adalah teman anda')) {
      return Icons.person_add; 
    }
    return null; 
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'NOTIFIKASI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children:
            notifications.map((notification) {
              return NotificationCard(
                name: notification['name'],
                message: notification['message'],
                time: notification['time'],
                comment: notification['comment'],
                imageAsset: notification['imageAsset'],
                icon: _getNotificationIcon(notification['message']),
              );
            }).toList(),
      ),
    );
  }
}
