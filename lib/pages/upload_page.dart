import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/post_provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _textController = TextEditingController();
  String? _username;
  String? _email;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedEmail = prefs.getString('email');
    if (mounted) {
      setState(() {
        _username = savedUsername ?? 'Pengguna Tidak Dikenal';
        _email = savedEmail ?? '';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postProvider = Provider.of<PostProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'UNGGAH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.displayLarge!.fontSize,
            color: theme.textTheme.displayLarge!.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile1.png'),
                  radius: 24,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _username ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: theme.textTheme.bodyMedium!.fontSize,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    Text(
                      _email ?? '',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Tulis Sesuatu...',
                  hintStyle: theme.textTheme.labelMedium,
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () async {
                final message = _textController.text.trim();
                if (message.isNotEmpty) {
                  final newPost = {
                    'username': _username,
                    'email': _email,
                    'time': 'Baru saja',
                    'message': message,
                    'logos': <String>[],
                    'profileImage': 'assets/images/profile1.png',
                    'like': 0,
                    'comment': 0,
                  };

                  await postProvider.addPostForUser(_email!, newPost);
                  
                  _textController.clear();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Postingan berhasil diunggah!'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Postingan tidak boleh kosong!')),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: theme.textTheme.headlineSmall!.color,
                foregroundColor: theme.textTheme.displaySmall!.color,
                textStyle: theme.textTheme.displayMedium,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Unggah'),
            ),
          ],
        ),
      ),
    );
  }
}
