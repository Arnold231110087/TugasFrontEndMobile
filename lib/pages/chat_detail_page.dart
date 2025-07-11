import 'package:flutter/material.dart';
import '../components/chat_bubble_component.dart';

class ChatDetailPage extends StatefulWidget {
  final Map<String, dynamic>
  chat; 

  const ChatDetailPage({super.key, required this.chat});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _addMessage(String text) {
    if (text.trim().isNotEmpty) {

      final newMessage = {
        'sender': 'you', 
        'time': 'Baru saja',
        'message': text.trim(),
      };

      setState(() {
        widget.chat['messages'].add(newMessage);
      });

      _messageController.clear(); 

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Map<String, dynamic>> messages = widget.chat['messages'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.chat['profileImage']),
            ),
            SizedBox(width: 16),
            Text(widget.chat['username'], style: theme.textTheme.displayLarge),
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
              onSelected: (value) {
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'hapus',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: theme.textTheme.bodySmall!.color,
                        ),
                        title: Text(
                          'Hapus obrolan',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'senyap',
                      child: ListTile(
                        leading: Icon(
                          Icons.notifications_off,
                          color: theme.textTheme.bodySmall!.color,
                        ),
                        title: Text(
                          'Mode senyap',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'blokir',
                      child: ListTile(
                        leading: Icon(
                          Icons.block,
                          color: theme.textTheme.bodySmall!.color,
                        ),
                        title: Text(
                          'Blokir pengguna',
                          style: theme.textTheme.bodyMedium,
                        ),
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
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  final Map<String, dynamic> current = messages[i];
                  final String? previousSender =
                      i > 0 ? messages[i - 1]['sender'] : null;

                  return Column(
                    children: [
                      if (previousSender != null)
                        SizedBox(
                          height:
                              previousSender == 'system' ||
                                      current['sender'] == 'system'
                                  ? 24
                                  : current['sender'] == previousSender
                                  ? 4
                                  : 12,
                        ),
                      ChatBubble(
                        chat: current,
                        username: widget.chat['username'],
                        profileImage: widget.chat['profileImage'],
                      ),
                    ],
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.price_change,
                      color: theme.textTheme.displaySmall!.color,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                'Ajukan Transaksi',
                                style: theme.textTheme.bodyLarge,
                              ),
                              content: TextField(
                                style: theme.textTheme.bodyMedium,
                                keyboardType: TextInputType.number,
                                cursorColor:
                                    theme.textTheme.headlineSmall!.color,
                                decoration: InputDecoration(
                                  prefixText: 'Rp  ',
                                  labelText: 'Harga',
                                  labelStyle: theme.textTheme.labelMedium,
                                  focusColor:
                                      theme.textTheme.headlineSmall!.color,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color:
                                          theme.textTheme.headlineSmall!.color!,
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Batal',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Ajukan',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: theme.textTheme.displaySmall!.color,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: theme.textTheme.displaySmall!.color,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: theme.textTheme.bodyMedium,
                      cursorColor: theme.textTheme.headlineSmall!.color,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
                        hintText: 'Ketik obrolan',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => _addMessage(_messageController.text),
                          color: theme.textTheme.headlineSmall!.color,
                        ),
                        hintStyle: theme.textTheme.labelMedium,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
