import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('password');
  }
}
