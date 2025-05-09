import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../pages/bank_page.dart';
import '../utils/rupiah_format.dart';

class ChatBubble extends StatefulWidget {
  final Map<String, dynamic> chat;
  final String username;
  final String profileImage;

  const ChatBubble({
    super.key,
    required this.chat,
    required this.username,
    required this.profileImage,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final ThemeData theme = Theme.of(context);

    final Map<String, dynamic> chat = widget.chat;
    final String username = widget.username;
    final String profileImage = widget.profileImage;

    if (chat['sender'] == 'system') {
      final Widget text;

      if (chat['type'] == 'proposal') {
        text = RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: chat['by'] == 'user' ? username : 'Anda',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' telah mengajukan sebuah transaksi dengan nominal '),
              TextSpan(
                text: rupiahFormat(chat['amount']),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      } else if (chat['type'] == 'rejected') {
        text = RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: chat['by'] == 'user' ? 'Anda' : username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' telah '),
              TextSpan(
                text: 'menolak',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
              TextSpan(text: ' transaksi dari '),
              TextSpan(
                text: chat['by'] == 'user' ? username : 'Anda',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' dengan nominal '),
              TextSpan(
                text: rupiahFormat(chat['amount']),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      } else {
        text = RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: chat['by'] == 'user' ? 'Anda' : username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' telah '),
              TextSpan(
                text: 'menerima',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              TextSpan(text: ' transaksi dari '),
              TextSpan(
                text: chat['by'] == 'user' ? username : 'Anda',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' dengan nominal '),
              TextSpan(
                text: rupiahFormat(chat['amount']),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: themeProvider.isDarkMode ? Color(0xFF1A1C24) : Color(0xFFF3F4F6),
                ),
                child: Column(
                  children: [
                    text,
                    if (chat['type'] == 'proposal' && chat['by'] == 'user') ...[
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  chat['type'] = 'rejected';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.red.shade800,
                                  ),
                                  child: Text('Tolak', style: theme.textTheme.displayMedium),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final bool? payed = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => BankPage(amount: chat['amount'])),
                                );

                                if (payed == true) {
                                  setState(() {
                                    chat['type'] = 'accepted';
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green.shade800,
                                  ),
                                  child: Text('Terima', style: theme.textTheme.displayMedium),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: chat['sender'] == 'you' ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chat['sender'] == 'user') ...[
          CircleAvatar(
            backgroundImage: AssetImage(profileImage),
            radius: 16,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: theme.dividerColor,
                ),
                borderRadius: BorderRadius.circular(12),
                color: chat['sender'] == 'you' ? theme.textTheme.headlineSmall!.color : theme.cardColor,
              ),
              child: Text(
                chat['message'],
                style: chat['sender'] == 'you' ? theme.textTheme.displayMedium : theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
