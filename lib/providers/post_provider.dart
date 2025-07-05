import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'Valerio Liuz Kienata',
      'time': '19 jam lalu',
      'message': 'Ini adalah postingan keduaku...',
      'logos': <String>[],
      'profileImage': 'images/profile1.png',
      'like': 2,
      'comment': 0,
    },
    {
      'username': 'Valerio Liuz Kienata',
      'time': 'kemarin',
      'message': 'Hello World!!! Ini adalah postingan pertamaku...',
      'logos': <String>[],
      'profileImage': 'images/profile1.png',
      'like': 1,
      'comment': 0,
    },
  ];

  List<Map<String, dynamic>> get posts => _posts;

  void addPost(Map<String, dynamic> newPost) {
    _posts.insert(0, newPost);
    notifyListeners();
  }
}