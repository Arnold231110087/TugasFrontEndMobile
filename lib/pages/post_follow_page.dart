import 'package:flutter/material.dart';
import '../components/full_screen_image_viewer.dart';

class PostDetailPage extends StatefulWidget {
  final String username;
  final String time;
  final String message;
  final List<String> logos;
  final String profileImage;
  final int like;
  final int comment;

  const PostDetailPage({
    super.key,
    required this.username,
    required this.time,
    required this.message,
    required this.logos,
    required this.profileImage,
    required this.like,
    required this.comment,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int likeCount = 0;
  bool isLiked = false;
  int commentCount = 0;
  List<String> comments = [];
  bool showComments = true; 
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likeCount = widget.like;
    commentCount = widget.comment;
    comments = [
      "Keren banget desainnya!",
      "Gue suka yang logo BCA!",
      "Gokil sih ini, inspiratif!",
      "Mantap bro!",
      "Detailnya rapi banget.",
      "Pakai tools apa ya bikin ini?",
    ];
  }

  void _toggleLike() {
    setState(() {
      if (!isLiked) {
        likeCount++;
      } else {
        likeCount--;
      }

      isLiked = !isLiked;
    });
  }

  void _addComment(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        comments.add(text.trim());
        commentCount++;
        _commentController.clear();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Post"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage(widget.profileImage)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.username, style: theme.textTheme.bodyMedium),
                    Text(widget.time, style: theme.textTheme.labelSmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.message, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.logos.asMap().entries.map((entry) {
                    final index = entry.key;
                    final logo = entry.value;

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => FullScreenImageViewer(
                                images: widget.logos,
                                initialIndex: index,
                              ),
                        );
                      },
                      child: Image.asset(logo, height: 40),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isLiked ? Colors.red : theme.iconTheme.color,
                  ),
                  onPressed: _toggleLike,
                ),
                const SizedBox(width: 4),
                Text('$likeCount', style: theme.textTheme.labelSmall),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(
                    Icons.comment_outlined,
                    size: 20,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      showComments =
                          !showComments;
                    });
                  },
                ),
                const SizedBox(width: 4),
                Text('$commentCount', style: theme.textTheme.labelSmall),
              ],
            ),

            const SizedBox(height: 24),

            if (showComments) ...[
              const SizedBox(height: 12),
              for (var comment in comments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 20,
                      ), 
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(comment, style: theme.textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Tambahkan komentar...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _addComment(_commentController.text),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
