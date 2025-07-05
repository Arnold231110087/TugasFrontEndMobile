import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../components/post_card_component.dart';
import '../providers/post_provider.dart'; 

class PostPage extends StatelessWidget {
  PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        if (postProvider.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 80,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                ),
                SizedBox(height: 16),
                Text(
                  'Belum ada postingan. Ayo unggah yang pertama!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 200), 
              ],
            ),
          );
        }

        return Column(
          children: [
            ...postProvider.posts
                .expand<Widget>(
                  (post) => [
                    PostCard(
                      username: post['username'],
                      time: post['time'],
                      message: post['message'],
                      logos: List<String>.from(post['logos']),
                      profileImage: post['profileImage'],
                      like: post['like'],
                      comment: post['comment'],
                    ),
                    const SizedBox(height: 24),
                  ],
                )
                .toList(),
          ],
        );
      },
    );
  }
}
