import 'package:flutter/material.dart';
import '../components/post_card_component.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key});

  final List<Map<String, dynamic>> posts = [
    {
      'username' : 'Valerio Liuz Kienata',
      'time': '19 jam lalu',
      'message': 'Ini adalah postingan keduaku...',
      'logos': [],
      'profileImage': 'images/profile1.png',
      'like': '2',
      'comment': '0',
    },
    {
      'username' : 'Valerio Liuz Kienata',
      'time': 'kemarin',
      'message': 'Hello World!!! Ini adalah postingan pertamaku...',
      'logos': [],
      'profileImage': 'images/profile1.png',
      'like': '1',
      'comment': '0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...posts.expand<Widget>((post) => [
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
        ]).toList()..removeLast(),
      ],
    );
  }
}
