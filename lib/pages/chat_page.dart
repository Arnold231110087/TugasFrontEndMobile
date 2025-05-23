import 'package:flutter/material.dart';
import 'chat_detail_page.dart';
import '../components/chat_card_component.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _allChats = [
    {
      'username': 'Kevin Durant',
      'profileImage': 'images/profile3.png',
      'messages': [
        {'sender': 'you', 'time': '2 jam lalu', 'message': 'Saya ingin sebuah logo yang unik'},
        {'sender': 'user', 'time': '58 menit lalu', 'message': 'Boleh kang, ingin logo seperti apa?'},
        {'sender': 'you', 'time': '50 menit lalu', 'message': 'Logo yang unik untuk team esport'},
        {'sender': 'user', 'time': '49 menit lalu', 'message': 'Sip, untuk harganya 350 rb yaa'},
        {
          'sender': 'system',
          'by': 'user',
          'time': '48 menit lalu',
          'type': 'proposal',
          'amount': 350000
        },
      ],
    },
    {
      'username': 'Rendy',
      'profileImage': 'images/profile5.png',
      'messages': [
        {'sender': 'user', 'time': '8 jam lalu', 'message': 'Halo mas, saya ingin request logo bisa?'},
        {'sender': 'you', 'time': '8 jam lalu', 'message': 'Bisa atuh kang. Ingin logo seperti apa?'},
        {'sender': 'you', 'time': '8 jam lalu', 'message': 'Silahkan ditulis aja semua aspek'},
        {'sender': 'user', 'time': '8 jam lalu', 'message': 'Saya ingin logo dengan elemen hijau'},
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final filteredChats = _isSearching
      ? _allChats.where((chat) => chat['username']!.toLowerCase().contains(_searchController.text.toLowerCase().trim())).toList()
      : _allChats;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: _isSearching
          ? Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.center,
                style: theme.textTheme.bodyMedium,
                cursorColor: theme.textTheme.headlineSmall!.color,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.textTheme.bodySmall!.color,
                  ),
                  hintText: 'Cari',
                  hintStyle: theme.textTheme.labelMedium,
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            )
          : Text(
              'OBROLAN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: theme.textTheme.displayLarge!.fontSize,
                color: theme.textTheme.displayLarge!.color,
              ),
            ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _isSearching
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: theme.textTheme.displaySmall!.color,
                  ),
                  color: theme.textTheme.displaySmall!.color,
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    color: theme.textTheme.displaySmall!.color
                  ),
                  color: theme.textTheme.displaySmall!.color,
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: filteredChats.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> chat = filteredChats[index];
          return ChatCard(
            chat: chat,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatDetailPage(chat: chat)),
              );

              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            }
          );
        },
      ),
    );
  }
}
