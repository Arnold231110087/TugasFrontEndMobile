import 'package:flutter/material.dart';
import 'package:logo_marketplace/utils/rupiah_format.dart';

class ChatCard extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;

  const ChatCard({
    super.key,
    required this.chat,
    required this.onTap,
  });

  Map<String, String> getLastChat() {
    final Map<String, dynamic> lastChat = chat['messages'].last;
    String message;

    if (lastChat['sender'] == 'system') {
      final String amount = rupiahFormat(lastChat['amount'] as int);
      final String sender = lastChat['by'] == 'user' ? chat['username'] : 'Anda';

      if (lastChat['type'] == 'proposal') {
        message = '$sender mengirimkan pengajuan senilai $amount';
      } else if (lastChat['type'] == 'rejected') {
        message = '$sender menolak pengajuan senilai $amount';
      } else if (lastChat['type'] == 'accepted') {
        message = '$sender menerima pengajuan senilai $amount';
      } else {
        message = lastChat['message'];
      }
    } else {
      message = lastChat['message'];
    }

    return {'message': message, 'time': lastChat['time']};
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, String> lastChat = getLastChat();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(chat['profileImage']),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: theme.textTheme.bodyMedium!.fontSize,
                      color: theme.textTheme.bodyMedium!.color,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    lastChat['message']!.length > 45 ? '${lastChat['message']!.substring(0, 45)}...' : lastChat['message']!,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Text(
              lastChat['time']!,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}