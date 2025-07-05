import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/post_provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _textController = TextEditingController(); 

  @override
  void dispose() {
    _textController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/profile1.png'),
                  radius: 24,
                ),
                SizedBox(width: 16),
                Text(
                  'Valerio Liuz Kienata', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: theme.textTheme.bodyMedium!.fontSize,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
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
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                final String message = _textController.text.trim();
                if (message.isNotEmpty) {
                  final newPost = {
                    'username': 'Valerio Liuz Kienata', 
                    'time': 'Baru saja', 
                    'message': message,
                    'logos': <String>[], 
                    'profileImage': 'images/profile1.png', 
                    'like': 0,
                    'comment': 0,
                  };
                  postProvider.addPost(newPost); 
                  _textController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Postingan berhasil diunggah!')),
                  );
                  Navigator.pop(context);
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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