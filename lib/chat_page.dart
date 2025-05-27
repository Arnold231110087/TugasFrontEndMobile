import 'package:flutter/material.dart';
import 'chat_detail.dart'; // Ganti sesuai path kamu

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Color primaryColor = const Color(0xFF1E3A8A);
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, String>> _allChats = [
    {
      'name': 'Kevin Durant',
      'message': 'Kevin durant ingin melakukan deal',
      'image': 'images/profile3.png',
    },
    {
      'name': 'Rendy',
      'message': 'Anda: Jika masih belum puas, silahkan chat saya saja',
      'image': 'images/profile5.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = _isSearching
        ? _allChats
            .where((chat) => chat['name']!
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList()
        : _allChats;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3FF),
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Cari...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              )
            : const Text(
                'Obrolan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredChats.length,
        itemBuilder: (context, index) {
          final chat = filteredChats[index];
          return _buildChatCard(
            name: chat['name']!,
            message: chat['message']!,
            imageAsset: chat['image']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailPage(name: chat['name']!),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildChatCard({
    required String name,
    required String message,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage(imageAsset), radius: 25),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
