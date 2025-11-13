import 'dart:async';
import 'package:flutter/material.dart';
import '../components/chat_bubble_component.dart';

class ChatDetailPage extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatDetailPage({
    super.key,
    required this.chat,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late StreamController<List<Map<String, dynamic>>> _messageStreamController;

  @override
  void initState() {
    super.initState();

    widget.chat['messages'] ??= [];

    _messageStreamController =
        StreamController<List<Map<String, dynamic>>>.broadcast();

    _messageStreamController.add(
      List<Map<String, dynamic>>.from(widget.chat['messages']),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageStreamController.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'sender': 'you',
      'time': 'baru saja',
      'message': _messageController.text.trim(),
    };

    widget.chat['messages'].add(newMessage);

    _messageStreamController
        .add(List<Map<String, dynamic>>.from(widget.chat['messages']));

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(backgroundImage: AssetImage(widget.chat['profileImage'])),
            const SizedBox(width: 16),
            Text(
              widget.chat['username'],
              style: theme.textTheme.displayLarge,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: theme.textTheme.displaySmall!.color,
              ),
              onSelected: (value) {},
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'hapus',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: theme.textTheme.bodySmall!.color),
                    title: Text('Hapus obrolan', style: theme.textTheme.bodyMedium),
                  ),
                ),
                PopupMenuItem(
                  value: 'senyap',
                  child: ListTile(
                    leading: Icon(Icons.notifications_off, color: theme.textTheme.bodySmall!.color),
                    title: Text('Mode senyap', style: theme.textTheme.bodyMedium),
                  ),
                ),
                PopupMenuItem(
                  value: 'blokir',
                  child: ListTile(
                    leading: Icon(Icons.block, color: theme.textTheme.bodySmall!.color),
                    title: Text('Blokir pengguna', style: theme.textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _messageStreamController.stream,
                initialData:
                    List<Map<String, dynamic>>.from(widget.chat['messages']),
                builder: (context, snapshot) {
                  final messages = snapshot.data ?? [];
                  List<Widget> chatWidgets = [];

                  for (int i = 0; i < messages.length; i++) {
                    final current = messages[i];
                    final String? previousSender =
                        i > 0 ? messages[i - 1]['sender'] : null;

                    if (previousSender != null) {
                      chatWidgets.add(SizedBox(
                        height: previousSender == 'system' ||
                                current['sender'] == 'system'
                            ? 24
                            : current['sender'] == previousSender
                                ? 4
                                : 12,
                      ));
                    }

                    chatWidgets.add(ChatBubble(
                      chat: current,
                      username: widget.chat['username'],
                      profileImage: widget.chat['profileImage'],
                    ));
                  }

                  return ListView(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    children: chatWidgets,
                  );
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: theme.appBarTheme.backgroundColor,
                border: Border(
                  top: BorderSide(width: 1, color: theme.dividerColor),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.price_change,
                        color: theme.textTheme.displaySmall!.color),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text('Ajukan Transaksi',
                              style: theme.textTheme.bodyLarge),
                          content: TextField(
                            style: theme.textTheme.bodyMedium,
                            keyboardType: TextInputType.number,
                            cursorColor: theme.textTheme.headlineSmall!.color,
                            decoration: InputDecoration(
                              prefixText: 'Rp  ',
                              labelText: 'Harga',
                              labelStyle: theme.textTheme.labelMedium,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color:
                                        theme.textTheme.headlineSmall!.color!),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal',
                                  style: theme.textTheme.bodyMedium),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Ajukan',
                                  style: theme.textTheme.headlineMedium),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt,
                        color: theme.textTheme.displaySmall!.color),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.mic,
                        color: theme.textTheme.displaySmall!.color),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: theme.textTheme.bodyMedium,
                      cursorColor: theme.textTheme.headlineSmall!.color,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
                        hintText: 'Ketik obrolan',
                        hintStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
