import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProvider extends ChangeNotifier {
  String? _username;
  String? _email;

  final List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> get posts => _posts;

  bool _isInitialized = false;

  PostProvider() {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'Anonim';
    _email = prefs.getString('email') ?? '';
    await _loadPostsForUser(_email!);
    notifyListeners();
  }

  Future<void> _loadPostsForUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final allPostsString = prefs.getString('allPosts');
    if (allPostsString != null) {
      final Map<String, dynamic> allPosts = json.decode(allPostsString);
      final userPosts = allPosts[email];
      if (userPosts != null && userPosts is List) {
        _posts
          ..clear()
          ..addAll(List<Map<String, dynamic>>.from(userPosts));
      }
    } else {
      _loadInitialPosts();
    }
  }

  Future<void> addPostForUser(String email, Map<String, dynamic> newPost) async {
    final prefs = await SharedPreferences.getInstance();
    final allPostsString = prefs.getString('allPosts');
    Map<String, dynamic> allPosts = {};

    if (allPostsString != null) {
      allPosts = json.decode(allPostsString);
    }

    if (!allPosts.containsKey(email)) {
      allPosts[email] = [];
    }

    final List<dynamic> userPosts = allPosts[email];
    userPosts.insert(0, newPost);

    allPosts[email] = userPosts;
    await prefs.setString('allPosts', json.encode(allPosts));

    _posts
      ..clear()
      ..addAll(List<Map<String, dynamic>>.from(userPosts));

    notifyListeners();
  }

  void _loadInitialPosts() {
    _posts.addAll([
      {
        'username': _username,
        'email': _email,
        'time': '19 jam lalu',
        'message': 'Ini adalah postingan keduaku...',
        'logos': <String>[],
        'profileImage': 'assets/images/profile1.png',
        'like': 2,
        'comment': 0,
      },
      {
        'username': _username,
        'email': _email,
        'time': 'kemarin',
        'message': 'Hello World!!! Ini adalah postingan pertamaku...',
        'logos': <String>[],
        'profileImage': 'assets/images/profile1.png',
        'like': 1,
        'comment': 0,
      },
    ]);
  }

  void clearPosts() {
    _posts.clear();
    notifyListeners();
  }
}